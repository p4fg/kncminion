angular.module('KncMinionApp', ['ngRoute', 'ngCookies', 'KncMinionApp.directives'])


.config(['$routeProvider', ($routeProvider) ->
  routeConfigs = [
    ['/','partials/main.html', minionController]
    ['/multi','partials/multi.html', multiMinionController]
  ]
  for routeConfig in routeConfigs
    route = routeConfig[0]
    routeParams = { templateUrl: routeConfig[1] }
    if routeConfig.length > 2
        routeParams.controller = routeConfig[2]
    if routeConfig.length > 3
        routeParams.resolve = routeConfig[3]
    $routeProvider.when(route, routeParams)
  return
])

#.config(['$httpProvider', ($httpProvider) ->
#  delete $httpProvider.defaults.headers.common['X-Requested-With']
#  return
#])

.run(['$rootScope', ($rootScope) ->
  return
])
