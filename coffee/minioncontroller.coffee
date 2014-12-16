@minionController = ['$scope','$rootScope','$timeout','$http', ($scope, $rootScope, $timeout, $http) ->
    
    setupValues = () ->
        $scope.dies = []
        $scope.hashrate = undefined
        $scope.hashratetimestamp = Date.now()
        $scope.intervals = [ { time: 60, text: "1m"}, { time: 600, text: "10m"}, { time: 3600, text: "1 hour"} ]
        $scope.selectedInterval = 600
        
        $scope.styles = [ "light", "dark" ]
        $rootScope.selectedStyle = $scope.styles[0]

        $scope.interpolations = [
            { value: "cardinal", text: "spline" }
            { value: "linear", text: "linear"} 
            { value: "step-after", text: "step"} 
        ]
        $scope.selectedInterpolation = $scope.interpolations[0].value

        $scope.metrics = []
        return

    restartStatusTimer = () ->
        $timeout(fetchStatus,5000)

    restartSummaryTimer = () ->
        $timeout(fetchSummary,5000)

    updateStatus = (data) ->
        if data.DEVS?
            $scope.dies = []
            $scope.hashrate = 0
            $scope.timestamp = data.STATUS[0].When
            for die in data.DEVS
                $scope.hashrate += die["MHS 20s"]

                # Mangle spaces
                die.MHS20s = die["MHS 20s"]

                $scope.dies.push(die)
            $scope.hashratetimestamp = Date.now()
            $scope.hashrate = parseFloat($scope.hashrate.toFixed(2))
        restartStatusTimer()
        return

    toReadableDuration = (s) ->
        sec_num = parseInt(s, 10)
        days = Math.floor(sec_num / 86400)
        hours   = Math.floor((sec_num - (days * 86400)) / 3600)
        minutes = Math.floor((sec_num - (days * 86400) - (hours * 3600)) / 60)
        seconds = sec_num - (days * 86400) - (hours * 3600) - (minutes * 60)

        if hours < 10
            hours   = "0" + hours
        if (minutes < 10)
            minutes = "0" + minutes
        if (seconds < 10)
            seconds = "0" + seconds
        time = hours+':'+minutes+':'+seconds
        if days == 1
            time = days + " day " + time
        if days > 1
            time = days + " days " + time
        return time

    updateSummary = (data) ->
        $scope.metrics = []
        targets = [
            ['MHS av','Average:', ' MH/s']
            ['Accepted','Accepted:', ' shares']
            ['Pool Rejected%','Pool rejected:','%']
            ['Pool Stale%','Pool stale:','%']
            ['Device Hardware%', 'HW Errors:', '%']
            ['Elapsed','Uptime:','',toReadableDuration]
        ]
        if data?
            for x in targets
                if data.SUMMARY[0][x[0]]?
                    value = data.SUMMARY[0][x[0]]
                    if x[3]?
                        value = x[3](value)
                    $scope.metrics.push({title: x[1], value:  value + x[2]})
        restartSummaryTimer()
        return


    failStatus = () ->
        restartStatusTimer()

    failSummary = () ->
        restartSummaryTimer()


    fetchStatus = () ->
        url = '/cgi-bin/bfgminer_procs.cgi'
        $http.get(url).success(updateStatus).error(failStatus)
        return

    fetchSummary = () ->
        url = '/cgi-bin/bfgminer_summary.cgi'
        $http.get(url).success(updateSummary).error(failSummary)
        return

    $scope.selectInterval = (interval) ->
        $scope.selectedInterval = interval.time

    $scope.selectStyle = (style) ->
        $rootScope.selectedStyle = style

    $scope.selectInterpolation = (interpolation) ->
        $scope.selectedInterpolation = interpolation.value

    setupValues()
    fetchStatus()
    fetchSummary()

    return
]