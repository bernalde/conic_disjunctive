"""Heat integration case study.

This is example 1 of the Yee & Grossmann, 1990 paper "Simultaneous optimization
models for heat integration--II".
DOI: 10.1016/0098-1354(90)85010-8

"""
from __future__ import division
from pyomo.environ import (Binary, ConcreteModel, NonNegativeReals, Objective,
                           Param, RangeSet, Set, Var, minimize)


def build_model():
    """Build the model."""
    m = ConcreteModel()
    m.streams = Set(initialize=['H1', 'H2', 'C1', 'C2'])
    m.hot_streams = Set(within=m.streams, initialize=['H1', 'H2'])
    m.cold_streams = Set(within=m.streams, initialize=['C1', 'C2'])
    num_stages = 2
    m.stages = RangeSet(num_stages)
    m.stages_plus_one = RangeSet(num_stages + 1)

    m.inlet_T = Param(
        m.streams, doc="Inlet temperature of stream [K]",
        initialize={'H1': 443,
                    'H2': 423,
                    'C1': 293,
                    'C2': 353})
    m.outlet_T = Param(
        m.streams, doc="Outlet temperature of stream [K]",
        initialize={'H1': 333,
                    'H2': 303,
                    'C1': 408,
                    'C2': 413})
    m.cold_util_outlet_T = Param(default=313)
    m.hot_util_outlet_T = Param(default=450)
    m.bigM_process_heat = Param(
        m.hot_streams, m.cold_streams, m.stages,
        doc="Big-M value for process match existence.",
        default=10000)
    m.bigM_cold_utility = Param(m.hot_streams, default=10000)
    m.bigM_hot_utility = Param(m.cold_streams, default=10000)

    m.heat_exchanged = Var(
        m.hot_streams, m.cold_streams, m.stages,
        domain=NonNegativeReals,
        doc="Heat exchanged from hot stream to cold stream in stage",
        initialize=1)
    m.FCp = Param(m.streams, doc="Flow times heat capacity of stream",
                  initialize={'H1': 30,
                              'H2': 15,
                              'C1': 20,
                              'C2': 40})
    m.cold_utility_needed = Var(
        m.hot_streams, doc="Cold utility need for hot stream",
        domain=NonNegativeReals, initialize=1)
    m.hot_utility_needed = Var(
        m.cold_streams, doc="Hot utility needed for cold stream",
        domain=NonNegativeReals, initialize=1)
    m.T = Var(m.streams, m.stages_plus_one,
              doc="Temperature of stream at hot end of stage")

    m.bigM_T_approach = Param(default=500)

    m.cost_cold_util = Param(default=20)
    m.cost_hot_util = Param(default=80)
    m.exchanger_fixed_cost = Param(
        m.hot_streams, m.cold_streams, default=0)
    m.utility_exchanger_fixed_cost = Param(
        m.streams, default=0)
    m.area_cost_coefficient = Param(
        m.hot_streams, m.cold_streams, default=1000)
    m.utility_area_cost_coefficient = Param(
        m.streams, initialize={
            strm: (1000 if strm in m.hot_streams else 1200)
            for strm in m.streams},
        doc="1200 for heaters. 1000 for all other exchangers."
    )
    m.area_cost_exponent = Param(default=0.6)
    m.U = Param(m.hot_streams, m.cold_streams, default=0.8)
    m.utility_U = Param(
        m.streams, initialize={
            strm: (0.8 if strm in m.hot_streams else 1.2)
            for strm in m.streams},
        doc="1.2 for heaters. 0.8 for everything else.")

    m.cold_util_T_in = Param(default=293)
    m.utility_area_cost_exponent = Param(m.streams, default=0.6)
    m.hot_util_T_in = Param(default=450)

    @m.Constraint(m.streams)
    def overall_stream_heat_balance(m, strm):
        if strm in m.hot_streams:
            return (m.inlet_T[strm] - m.outlet_T[strm]) * m.FCp[strm] == (
                sum(m.heat_exchanged[strm, cold, stg]
                    for cold in m.cold_streams for stg in m.stages)
                + m.cold_utility_needed[strm])
        if strm in m.cold_streams:
            return (m.outlet_T[strm] - m.inlet_T[strm]) * m.FCp[strm] == (
                sum(m.heat_exchanged[hot, strm, stg]
                    for hot in m.hot_streams for stg in m.stages)
                + m.hot_utility_needed[strm])

    @m.Constraint(m.stages, m.streams)
    def stage_heat_balance(m, stg, strm):
        if strm in m.hot_streams:
            return (m.T[strm, stg] - m.T[strm, stg + 1]) * m.FCp[strm] == sum(
                m.heat_exchanged[strm, cold, stg] for cold in m.cold_streams)
        if strm in m.cold_streams:
            return (m.T[strm, stg] - m.T[strm, stg + 1]) * m.FCp[strm] == sum(
                m.heat_exchanged[hot, strm, stg] for hot in m.hot_streams)

    @m.Constraint(m.streams)
    def inlet_temperature_assignment(m, strm):
        return m.inlet_T[strm] == (m.T[strm, 1] if strm in m.hot_streams else
                                   m.T[strm, num_stages + 1])

    @m.Constraint(m.stages, m.streams)
    def stagewise_temperature_feasibility(m, stg, strm):
        return m.T[strm, stg] >= m.T[strm, stg + 1]

    @m.Constraint(m.hot_streams)
    def hot_stream_exit_temperature_feasibility(m, strm):
        return m.outlet_T[strm] <= m.T[strm, num_stages + 1]

    @m.Constraint(m.cold_streams)
    def cold_stream_exit_temperature_feasibility(m, strm):
        return m.outlet_T[strm] >= m.T[strm, 1]

    @m.Constraint(m.hot_streams)
    def cold_utility_load(m, strm):
        return ((m.T[strm, num_stages + 1] - m.outlet_T[strm])
                * m.FCp[strm]) == m.cold_utility_needed[strm]

    @m.Constraint(m.cold_streams)
    def hot_utility_load(m, strm):
        return ((m.outlet_T[strm] - m.T[strm, 1])
                * m.FCp[strm]) == m.hot_utility_needed[strm]

    m.match_exists = Var(
        m.hot_streams, m.cold_streams, m.stages,
        doc="Binary variable indicating if a match between a "
        "hot and cold stream exists at a stage.",
        domain=Binary)
    m.cold_utility_exists = Var(
        m.hot_streams, doc="Binary variable indicating if a "
        "cold utility exists for a hot stream.",
        domain=Binary)
    m.hot_utility_exists = Var(
        m.cold_streams, doc="Binary variable indicating if a "
        "hot utility exists for a cold stream.",
        domain=Binary)

    @m.Constraint(m.stages, m.hot_streams, m.cold_streams)
    def process_match_existence(m, stg, hot, cold):
        return (m.heat_exchanged[hot, cold, stg]
                - (m.bigM_process_heat[hot, cold, stg]
                   * m.match_exists[hot, cold, stg])) <= 0

    @m.Constraint(m.hot_streams)
    def cold_utility_existence(m, strm):
        return (m.cold_utility_needed[strm]
                - (m.bigM_cold_utility[strm]
                   * m.cold_utility_exists[strm])) <= 0

    @m.Constraint(m.cold_streams)
    def hot_utility_existence(m, strm):
        return (m.hot_utility_needed[strm]
                - (m.bigM_hot_utility[strm]
                   * m.hot_utility_exists[strm])) <= 0

    m.exchanger_approach_T = Var(
        m.hot_streams, m.cold_streams, m.stages_plus_one,
        doc="Temperature approach for exchanger between "
        "hot and cold stream at a stage.",
        bounds=(0.1, 500)
    )
    m.utility_approach_T = Var(
        m.streams, doc="Temperature approach for utility exchangers",
        bounds=(0.1, 500))

    @m.Constraint(m.stages, m.hot_streams, m.cold_streams)
    def stage_hot_approach_temperature(m, stg, hot, cold):
        return m.exchanger_approach_T[hot, cold, stg] <= (
            m.T[hot, stg] - m.T[cold, stg] + (
                m.bigM_T_approach * (1 - m.match_exists[hot, cold, stg])))

    @m.Constraint(m.stages, m.hot_streams, m.cold_streams)
    def stage_cold_approach_temperature(m, stg, hot, cold):
        return m.exchanger_approach_T[hot, cold, stg + 1] <= (
            m.T[hot, stg + 1] - m.T[cold, stg + 1] + (
                m.bigM_T_approach * (1 - m.match_exists[hot, cold, stg])))

    @m.Constraint(m.hot_streams)
    def cold_utility_approach_temperature(m, strm):
        return m.utility_approach_T[strm] <= (
            m.T[strm, num_stages + 1] - m.cold_util_outlet_T + (
                m.bigM_T_approach * (1 - m.cold_utility_exists[strm])))

    @m.Constraint(m.cold_streams)
    def hot_utility_approach_temperature(m, strm):
        return m.utility_approach_T[strm] <= (
            m.hot_util_outlet_T - m.T[strm, 1] + (
                m.bigM_T_approach * (1 - m.hot_utility_exists[strm])))

    @m.Expression(m.hot_streams)
    def cold_utility_cost(m, strm):
        return m.cost_cold_util * m.cold_utility_needed[strm]

    @m.Expression(m.cold_streams)
    def hot_utility_cost(m, strm):
        return m.cost_hot_util * m.hot_utility_needed[strm]

    @m.Expression(m.stages, m.hot_streams, m.cold_streams)
    def match_exchanger_fixed_cost(m, stg, hot, cold):
        return (m.exchanger_fixed_cost[hot, cold]
                * m.match_exists[hot, cold, stg])

    @m.Expression(m.hot_streams)
    def cold_utility_exchanger_fixed_cost(m, strm):
        return (m.utility_exchanger_fixed_cost[strm]
                * m.cold_utility_needed[strm])

    @m.Expression(m.cold_streams)
    def hot_utility_exchanger_fixed_cost(m, strm):
        return (m.utility_exchanger_fixed_cost[strm]
                * m.hot_utility_needed[strm])

    @m.Expression(m.stages, m.hot_streams, m.cold_streams)
    def match_exchanger_area(m, stg, hot, cold):
        return m.heat_exchanged[hot, cold, stg] / (
            m.U[hot, cold] * (
                m.exchanger_approach_T[hot, cold, stg] *
                m.exchanger_approach_T[hot, cold, stg + 1] *
                (m.exchanger_approach_T[hot, cold, stg] +
                 m.exchanger_approach_T[hot, cold, stg + 1]) / 2
            ) ** (1 / 3))

    @m.Expression(m.stages, m.hot_streams, m.cold_streams)
    def match_exchanger_area_cost(m, stg, hot, cold):
        return (m.area_cost_coefficient[hot, cold] *
                m.match_exchanger_area[stg, hot, cold] ** m.area_cost_exponent)

    @m.Expression(m.streams)
    def utility_exchanger_area(m, strm):
        if strm in m.hot_streams:
            return m.cold_utility_needed[strm] / (
                m.utility_U[strm] * (
                    (m.utility_approach_T[strm] *
                     (m.outlet_T[strm] - m.cold_util_T_in)) *
                    (m.utility_approach_T[strm] +
                     (m.outlet_T[strm] - m.cold_util_T_in))
                    / 2
                ) ** (1 / 3))
        else:
            return m.hot_utility_needed[strm] / (
                m.utility_U[strm] * (
                    (m.utility_approach_T[strm] *
                     (m.hot_util_T_in - m.outlet_T[strm])) *
                    (m.utility_approach_T[strm] +
                     (m.hot_util_T_in - m.outlet_T[strm]))
                    / 2
                ) ** (1 / 3))

    @m.Expression(m.streams)
    def utility_exchanger_area_cost(m, strm):
        return (m.utility_area_cost_coefficient[strm] *
                m.utility_exchanger_area[strm]
                ** m.utility_area_cost_exponent[strm])

    m.total_cost = Objective(
        expr=sum(m.cold_utility_cost[strm] for strm in m.hot_streams)
        + sum(m.hot_utility_cost[strm] for strm in m.cold_streams)
        # + sum(m.match_exchanger_fixed_cost[stg, hot, cold]
        #       for stg in m.stages
        #       for hot in m.hot_streams
        #       for cold in m.cold_streams)
        # + sum(m.cold_utility_exchanger_fixed_cost[strm]
        #       for strm in m.hot_streams)
        # + sum(m.hot_utility_exchanger_fixed_cost[strm]
        #       for strm in m.cold_streams)
        + sum(m.match_exchanger_area_cost[stg, hot, cold]
              for stg in m.stages
              for hot in m.hot_streams
              for cold in m.cold_streams)
        + sum(m.utility_exchanger_area_cost[strm]
              for strm in m.streams),
        sense=minimize
    )
    return m


if __name__ == "__main__":
    m = build_model()
    from pyomo.environ import SolverFactory, TransformationFactory
    # m.display()
    # TransformationFactory('core.relax_integrality').apply_to(m)
    # result = SolverFactory('ipopt').solve(
    #     m, tee=True, options={'halt_on_ampl_error': 'no'})
    # result = SolverFactory('gams').solve(m, tee=True, solver='conopt')
    result = SolverFactory('gams').solve(
        m, tee=True, solver='baron',
        add_options=['OPTION optcr = 0.001;'],
        keepfiles=True)
    # result = SolverFactory('gams').solve(m, tee=True, solver='dicopt',
    #                                      add_options=['OPTION NLP = ipopt;'])
    print(result)
    m.display()
    m.cold_utility_cost.display()
    m.hot_utility_cost.display()
    m.utility_exchanger_area.display()
    m.match_exchanger_area.display()
