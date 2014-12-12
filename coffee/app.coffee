angular.module('KncMinionApp', ['ngRoute', 'KncMinionApp.directives'])


.config(['$routeProvider', ($routeProvider) ->
  routeConfigs = [
    ['/','partials/main.html', minionController]
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

.run(['$rootScope', ($rootScope) ->
  return
])

