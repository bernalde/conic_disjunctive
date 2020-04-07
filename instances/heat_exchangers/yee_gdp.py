"""Heat integration case study.

This is example 1 of the Yee & Grossmann, 1990 paper "Simultaneous optimization
models for heat integration--II".
DOI: 10.1016/0098-1354(90)85010-8

This is a model reformulation to use Generalized Disjunctive Programming.

"""
from __future__ import division

from pyomo.environ import (ConcreteModel, Constraint, NonNegativeReals,
                           Objective, Param, RangeSet, Set, Suffix, Var,
                           minimize)
from pyomo.gdp import Disjunct, Disjunction


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
    # m.bigM_process_heat = Param(
    #     m.hot_streams, m.cold_streams, m.stages,
    #     doc="Big-M value for process match existence.",
    #     default=10000)
    # m.bigM_cold_utility = Param(m.hot_streams, default=10000)
    # m.bigM_hot_utility = Param(m.cold_streams, default=10000)

    m.heat_exchanged = Var(
        m.hot_streams, m.cold_streams, m.stages,
        domain=NonNegativeReals,
        doc="Heat exchanged from hot stream to cold stream in stage",
        initialize=1, bounds=(0, 5000))
    m.FCp = Param(m.streams, doc="Flow times heat capacity of stream",
                  initialize={'H1': 30,
                              'H2': 15,
                              'C1': 20,
                              'C2': 40})
    m.utility_needed = Var(
        m.streams,
        doc="Hot or cold utility needed to bring a stream "
        "to its required exit temperature.",
        domain=NonNegativeReals, initialize=1, bounds=(0, 5000))
    m.T = Var(m.streams, m.stages_plus_one,
              doc="Temperature of stream at hot end of stage",
              bounds=(293, 450))

    m.bigM_T_approach = Param(default=500)

    m.BigM = Suffix(direction=Suffix.LOCAL)

    m.cost_cold_util = Param(default=20)
    m.cost_hot_util = Param(default=80)
    m.exchanger_fixed_cost = Param(
        m.hot_streams, m.cold_streams, default=0)
    m.utility_exchanger_unit_cost = Param(
        m.streams, default=0)
    m.area_cost_coefficient = Param(
        m.hot_streams, m.cold_streams, default=1000)
    m.utility_area_cost_coefficient = Param(
        m.streams, initialize={
            strm: (1000 if strm in m.hot_streams else 1200)
            for strm in m.streams},
        doc="1200 for heaters. 1000 for all other exchangers.")
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

    m.exchanger_approach_T = Var(
        m.hot_streams, m.cold_streams, m.stages_plus_one,
        doc="Temperature approach for exchanger between "
        "hot and cold stream at a stage.",
        bounds=(0.1, 500))
    m.utility_approach_T = Var(
        m.streams, doc="Temperature approach for utility exchangers",
        bounds=(0.1, 500))

    @m.Constraint(m.streams)
    def overall_stream_heat_balance(m, strm):
        if strm in m.hot_streams:
            return (m.inlet_T[strm] - m.outlet_T[strm]) * m.FCp[strm] == (
                sum(m.heat_exchanged[strm, cold, stg]
                    for cold in m.cold_streams for stg in m.stages)
                + m.utility_needed[strm])
        if strm in m.cold_streams:
            return (m.outlet_T[strm] - m.inlet_T[strm]) * m.FCp[strm] == (
                sum(m.heat_exchanged[hot, strm, stg]
                    for hot in m.hot_streams for stg in m.stages)
                + m.utility_needed[strm])

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
                * m.FCp[strm]) == m.utility_needed[strm]

    @m.Constraint(m.cold_streams)
    def hot_utility_load(m, strm):
        return ((m.outlet_T[strm] - m.T[strm, 1])
                * m.FCp[strm]) == m.utility_needed[strm]

    m.utility_cost = Var(
        m.streams, doc="Annual utility cost", domain=NonNegativeReals,
        bounds=(0, 100000))

    m.match_exchanger_fixed_cost = Var(
        m.stages, m.hot_streams, m.cold_streams,
        doc="Fixed cost for an exchanger between a hot and cold stream.",
        domain=NonNegativeReals, bounds=(0, 5000))

    m.utility_exchanger_fixed_cost = Var(
        m.streams,
        doc="Fixed cost for the utility exchanger.",
        domain=NonNegativeReals, bounds=(0, 5000))

    m.match_exchanger_area = Var(
        m.stages, m.hot_streams, m.cold_streams,
        doc="Exchanger area for a match between a hot and cold stream.",
        domain=NonNegativeReals, bounds=(0, 500))
    m.match_exchanger_area_cost = Var(
        m.stages, m.hot_streams, m.cold_streams,
        doc="Capital cost contribution from exchanger area.",
        domain=NonNegativeReals, bounds=(0, 100000))

    m.utility_exchanger_area = Var(
        m.streams,
        doc="Exchanger area for the hot or cold utility for a stream.",
        domain=NonNegativeReals, bounds=(0, 500))
    m.utility_exchanger_area_cost = Var(
        m.streams,
        doc="Capital cost contribution from utility exchanger area.",
        domain=NonNegativeReals, bounds=(0, 100000))

    def _match_exists(disj, hot, cold, stg):
        # disj.conventional = Disjunct()
        # disj.modular = Disjunct(m.module_sizes)
        disj.match_exchanger_area_cost = Constraint(
            expr=m.match_exchanger_area_cost[stg, hot, cold] * 1E-3 >=
            m.area_cost_coefficient[hot, cold] * 1E-3 *
            m.match_exchanger_area[stg, hot, cold] ** m.area_cost_exponent)
        m.BigM[disj.match_exchanger_area_cost] = 100
        disj.match_exchanger_area = Constraint(
            expr=m.match_exchanger_area[stg, hot, cold] * (
                m.U[hot, cold] * (
                    m.exchanger_approach_T[hot, cold, stg] *
                    m.exchanger_approach_T[hot, cold, stg + 1] *
                    (m.exchanger_approach_T[hot, cold, stg] +
                     m.exchanger_approach_T[hot, cold, stg + 1]) / 2
                ) ** (1 / 3)) >=
            m.heat_exchanged[hot, cold, stg])
        m.BigM[disj.match_exchanger_area] = 5000
        disj.match_exchanger_fixed_cost = Constraint(
            expr=m.match_exchanger_fixed_cost[stg, hot, cold] ==
            m.exchanger_fixed_cost[hot, cold])
        disj.stage_hot_approach_temperature = Constraint(
            expr=m.exchanger_approach_T[hot, cold, stg] <=
            m.T[hot, stg] - m.T[cold, stg])
        disj.stage_cold_approach_temperature = Constraint(
            expr=m.exchanger_approach_T[hot, cold, stg + 1] <=
            m.T[hot, stg + 1] - m.T[cold, stg + 1])
        pass

    def _match_absent(disj, hot, cold, stg):
        disj.no_match_exchanger_cost = Constraint(
            expr=m.match_exchanger_area_cost[stg, hot, cold] == 0)
        disj.no_match_exchanger_area = Constraint(
            expr=m.match_exchanger_area[stg, hot, cold] == 0)
        disj.no_match_exchanger_fixed_cost = Constraint(
            expr=m.match_exchanger_fixed_cost[stg, hot, cold] == 0)
        disj.no_heat_exchange = Constraint(
            expr=m.heat_exchanged[hot, cold, stg] == 0)
        pass

    m.match_exists = Disjunct(
        m.hot_streams, m.cold_streams, m.stages,
        doc="Disjunct for the presence of an exchanger between a "
        "hot stream and a cold stream at a stage.", rule=_match_exists)
    m.match_absent = Disjunct(
        m.hot_streams, m.cold_streams, m.stages,
        doc="Disjunct for the absence of an exchanger between a "
        "hot stream and a cold stream at a stage.", rule=_match_absent)

    def _match_exists_or_absent(m, hot, cold, stg):
        return [m.match_exists[hot, cold, stg], m.match_absent[hot, cold, stg]]
    m.match_exists_or_absent = Disjunction(
        m.hot_streams, m.cold_streams, m.stages,
        doc="Disjunction between presence or absence of an exchanger between "
        "a hot stream and a cold stream at a stage.",
        rule=_match_exists_or_absent)

    def _utility_exists(disj, strm):
        disj.utility_exchanger_area_cost = Constraint(
            expr=m.utility_exchanger_area_cost[strm] * 1E-3 >=
            m.utility_area_cost_coefficient[strm] * 1E-3 *
            m.utility_exchanger_area[strm]
            ** m.utility_area_cost_exponent[strm])
        m.BigM[disj.utility_exchanger_area_cost] = 100
        # temperature difference between utility and process stream at process
        # stream outlet
        outlet_T_diff = ((m.outlet_T[strm] - m.cold_util_T_in)
                         if strm in m.hot_streams else
                         (m.hot_util_T_in - m.outlet_T[strm]))
        disj.utility_exchanger_area = Constraint(
            expr=m.utility_exchanger_area[strm] * (
                m.utility_U[strm] * (
                    (m.utility_approach_T[strm] *
                     outlet_T_diff) *
                    (m.utility_approach_T[strm] +
                     outlet_T_diff)
                    / 2
                ) ** (1 / 3)) >=
            m.utility_needed[strm])
        m.BigM[disj.utility_exchanger_area] = 5000
        disj.utility_exchanger_fixed_cost = Constraint(
            expr=m.utility_exchanger_fixed_cost[strm] ==
            m.utility_exchanger_unit_cost[strm])
        disj.utility_cost = Constraint(
            expr=m.utility_cost[strm] == m.utility_needed[strm] * (
                m.cost_cold_util if strm in m.hot_streams
                else m.cost_hot_util))
        disj.utility_approach_temperature = Constraint(
            expr=m.utility_approach_T[strm] <= (
                (m.T[strm, num_stages + 1] - m.cold_util_outlet_T)
                if strm in m.hot_streams else
                (m.hot_util_outlet_T - m.T[strm, 1])))
        disj.minimum_utility_approach_temperature = Constraint(
            expr=m.utility_approach_T[strm] >= 0.1)
        pass

    def _utility_absent(disj, strm):
        disj.no_area_cost = Constraint(
            expr=m.utility_exchanger_area_cost[strm] == 0)
        disj.no_area = Constraint(expr=m.utility_exchanger_area[strm] == 0)
        disj.no_fixed_cost = Constraint(
            expr=m.utility_exchanger_fixed_cost[strm] == 0)
        disj.no_utility_cost = Constraint(expr=m.utility_cost[strm] == 0)
        disj.no_utility = Constraint(expr=m.utility_needed[strm] == 0)
        pass

    m.utility_exists = Disjunct(
        m.streams, doc="Disjunct for the presence of a utility exchanger "
        "for a stream.",
        rule=_utility_exists)
    m.utility_absent = Disjunct(
        m.streams, doc="Disjunct for the absence of a utility exchanger "
        "for a stream.",
        rule=_utility_absent)

    def _utility_exists_or_absent(m, strm):
        return [m.utility_exists[strm], m.utility_absent[strm]]
    m.utility_exists_or_absent = Disjunction(
        m.streams,
        doc="Disjunction between presence or absence of a utility exchanger "
        "for a stream.",
        rule=_utility_exists_or_absent)

    m.total_cost = Objective(
        expr=sum(m.utility_cost[strm] for strm in m.streams)
        + sum(m.match_exchanger_fixed_cost[stg, hot, cold]
              for stg in m.stages
              for hot in m.hot_streams
              for cold in m.cold_streams)
        + sum(m.utility_exchanger_fixed_cost[strm]
              for strm in m.streams)
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
    TransformationFactory('gdp.bigm').apply_to(m)
    result = SolverFactory('gams').solve(
        m, tee=True, solver='baron',
        add_options=['OPTION optcr = 0.01;'],
        keepfiles=False)
    # result = SolverFactory('gams').solve(m, tee=True, solver='dicopt',
    #                                      add_options=['OPTION NLP = ipopt;'])
    print(result)
    m.utility_cost.display()
    m.utility_exchanger_area.display()
    m.match_exchanger_area.display()
