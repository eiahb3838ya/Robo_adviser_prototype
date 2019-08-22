from ..portfilio import portfolio_Markowitz,portfolio_RiskParity,portfolio_CVaR

from ..indicators_factory import strategyR
from ..indicators_factory.data_generator import getCumRet_Drawdowns
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import plotly.graph_objs as go
from plotly.offline import plot

class PortfolioMarkowitzChartData(APIView):
    def get(self, request, format = None):
        portfolioName = "Markowitz"

        try:
            # https: // stackoverflow.com / questions / 18045867 / post - jquery - array - to - django
            target_strategy = request.GET.getlist('target_strategy[]')
            print("we are now in Portfolio{}ChartData: ".format(portfolioName), target_strategy)
        except Exception as e:
            print(str(e))

        pairs = [tuple(aPair.split("_")) for aPair in target_strategy]
        first = True
        equityList = []
        for target, strategy in pairs:
            if first:
                firstStrategyResult = strategyR.main(target, strategy, return_history_data=True)
                Ret = firstStrategyResult['targetRet']
                history_data_df = firstStrategyResult['history_data_df']
                tmpStrategyRet = firstStrategyResult['strategyRet']
                first = False
            else:
                tmpStrategyResult = strategyR.main(target, strategy, history_data_df= history_data_df)
                tmpStrategyRet = tmpStrategyResult['strategyRet']
            equityList.append(tmpStrategyRet)
        thisReturn = globals()["portfolio_{}".format(portfolioName)].main(equityList, Ret)

        Equity_All_df = thisReturn['Equity_All_df']
        RL_Corr = thisReturn['RL_Corr']
        RL_Wt = thisReturn['RL_Wt']
        RL_Ret = thisReturn['RL_Ret']

        # get cumulative return and dd
        portfolioCumRet, portfolioDrawdowns = getCumRet_Drawdowns(RL_Ret)

        # plot everything
        corr_lint_div = plot_line_div(RL_Corr, title="Strategy Correlation", yaxis_title='Correlation')
        ret_line_div = plot_line_div(Equity_All_df, title="Strategy Return", yaxis_title='Ret')
        portfolio_ret_div = plot_line_div(RL_Ret, title="Portfolio Return", yaxis_title='Ret')
        portfolio_cum_ret_div = plot_line_div(portfolioCumRet, title="Portfolio Cum Return", yaxis_title='CumRet')
        portfolio_dd_div = plot_line_div(portfolioDrawdowns, title="Portfolio Draw Down", yaxis_title='DD')

        wt_bar_div = plot_stack_bar_div(RL_Wt, title="{} Portfolio Weight".format(portfolioName), yaxis_title='Weight')

        data = {
            "ret_line_div": ret_line_div,
            "corr_lint_div": corr_lint_div,
            "wt_bar_div":wt_bar_div,
            "portfolio_ret_div": portfolio_ret_div,
            "portfolio_cum_ret_div": portfolio_cum_ret_div,
            'portfolio_dd_div': portfolio_dd_div


        }

        return( Response( data ) )

class PortfolioRiskParityChartData(APIView):
    def get(self, request, format = None):
        portfolioName = "RiskParity"

        try:
            # https: // stackoverflow.com / questions / 18045867 / post - jquery - array - to - django
            target_strategy = request.GET.getlist('target_strategy[]')
            print("we are now in Portfolio{}ChartData: ".format(portfolioName), target_strategy)
        except Exception as e:
            print(str(e))

        pairs = [tuple(aPair.split("_")) for aPair in target_strategy]
        first = True
        equityList = []
        for target, strategy in pairs:
            if first:
                firstStrategyResult = strategyR.main(target, strategy, return_history_data=True)
                Ret = firstStrategyResult['targetRet']
                history_data_df = firstStrategyResult['history_data_df']
                tmpStrategyRet = firstStrategyResult['strategyRet']
                first = False
            else:
                tmpStrategyResult = strategyR.main(target, strategy, history_data_df= history_data_df)
                tmpStrategyRet = tmpStrategyResult['strategyRet']
            equityList.append(tmpStrategyRet)
        thisReturn = globals()["portfolio_{}".format(portfolioName)].main(equityList, Ret)

        Equity_All_df = thisReturn['Equity_All_df']
        RL_Corr = thisReturn['RL_Corr']
        RL_Wt = thisReturn['RL_Wt']
        RL_Ret = thisReturn['RL_Ret']

        # get cumulative return and dd
        portfolioCumRet, portfolioDrawdowns = getCumRet_Drawdowns(RL_Ret)

        # plot everything
        corr_lint_div = plot_line_div(RL_Corr, title="Strategy Correlation", yaxis_title='Correlation')
        ret_line_div = plot_line_div(Equity_All_df, title="Strategy Return", yaxis_title='Ret')
        portfolio_ret_div = plot_line_div(RL_Ret, title="Portfolio Return", yaxis_title='Ret')
        portfolio_cum_ret_div = plot_line_div(portfolioCumRet, title="Portfolio Cum Return", yaxis_title='CumRet')
        portfolio_dd_div = plot_line_div(portfolioDrawdowns, title="Portfolio Draw Down", yaxis_title='DD')

        wt_bar_div = plot_stack_bar_div(RL_Wt, title="{} Portfolio Weight".format(portfolioName), yaxis_title='Weight')

        data = {
            "ret_line_div": ret_line_div,
            "corr_lint_div": corr_lint_div,
            "wt_bar_div":wt_bar_div,
            "portfolio_ret_div": portfolio_ret_div,
            "portfolio_cum_ret_div": portfolio_cum_ret_div,
            'portfolio_dd_div': portfolio_dd_div


        }

        return( Response( data ) )

class PortfolioCVaRChartData(APIView):
    def get(self, request, format = None):
        portfolioName = "CVaR"

        try:
            # https: // stackoverflow.com / questions / 18045867 / post - jquery - array - to - django
            target_strategy = request.GET.getlist('target_strategy[]')
            print("we are now in Portfolio{}ChartData: ".format(portfolioName), target_strategy)
        except Exception as e:
            print(str(e))

        pairs = [tuple(aPair.split("_")) for aPair in target_strategy]
        first = True
        equityList = []
        for target, strategy in pairs:
            if first:
                firstStrategyResult = strategyR.main(target, strategy, return_history_data=True)
                Ret = firstStrategyResult['targetRet']
                history_data_df = firstStrategyResult['history_data_df']
                tmpStrategyRet = firstStrategyResult['strategyRet']
                first = False
            else:
                tmpStrategyResult = strategyR.main(target, strategy, history_data_df= history_data_df)
                tmpStrategyRet = tmpStrategyResult['strategyRet']
            equityList.append(tmpStrategyRet)
        thisReturn = globals()["portfolio_{}".format(portfolioName)].main(equityList, Ret)

        Equity_All_df = thisReturn['Equity_All_df']
        RL_Corr = thisReturn['RL_Corr']
        RL_Wt = thisReturn['RL_Wt']
        RL_Ret = thisReturn['RL_Ret']

        # get cumulative return and dd
        portfolioCumRet, portfolioDrawdowns = getCumRet_Drawdowns(RL_Ret)

        # plot everything
        corr_lint_div = plot_line_div(RL_Corr, title="Strategy Correlation", yaxis_title='Correlation')
        ret_line_div = plot_line_div(Equity_All_df, title="Strategy Return", yaxis_title='Ret')
        portfolio_ret_div = plot_line_div(RL_Ret, title="Portfolio Return", yaxis_title='Ret')
        portfolio_cum_ret_div = plot_line_div(portfolioCumRet, title="Portfolio Cum Return", yaxis_title='CumRet')
        portfolio_dd_div = plot_line_div(portfolioDrawdowns, title="Portfolio Draw Down", yaxis_title='DD')

        wt_bar_div = plot_stack_bar_div(RL_Wt, title="{} Portfolio Weight".format(portfolioName), yaxis_title='Weight')

        data = {
            "ret_line_div": ret_line_div,
            "corr_lint_div": corr_lint_div,
            "wt_bar_div":wt_bar_div,
            "portfolio_ret_div": portfolio_ret_div,
            "portfolio_cum_ret_div": portfolio_cum_ret_div,
            'portfolio_dd_div': portfolio_dd_div


        }

        return( Response( data ) )
def plot_line_div(df, title = None, yaxis_title = None):

    fig = go.Figure()
    date = df['index']

    for i in range(1,len(df.columns)):
        trace = go.Scatter(x=date, y=df.iloc[:,i],
                                 mode='lines+markers',
                                 name=df.columns[i])
        fig.add_trace(trace)
    # fig.layout.title.text = title
    fig.layout.update({
        'title':title,
        'yaxis_title':yaxis_title
    })
    plot_div = plot(fig, output_type='div', include_plotlyjs=True)
    return(plot_div)


def plot_stack_bar_div(df, title = None, yaxis_title = None):
    fig = go.Figure()
    data = []
    date = df['index']

    for i in range(1, len(df.columns)):
        go.Bar(x=[1, 2, 3], y=[1, 3, 2])
        trace = go.Bar(x=date, y=df.iloc[:, i],
                           name=df.columns[i])
        fig.add_trace(trace)
    fig.layout.update({
        'title': title,
        'yaxis_title': yaxis_title,
        'barmode': "stack",
    })
    plot_div = plot(fig, output_type='div', include_plotlyjs=True)
    return (plot_div)
