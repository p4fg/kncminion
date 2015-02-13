@multiMinionController = ['$scope','$rootScope','$timeout','$interval', '$http', '$location', '$cookies', ($scope, $rootScope, $timeout, $interval, $http, $location, $cookies) ->
    
    

    setupValues = () ->
        $scope.titans = []
        $scope.hosts = []

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

    titanComparer = (a,b) ->
        if a.id == 'localhost'
            return -1
        if b.id == 'localhost'
            return 1
        return a.id.localeCompare(b.id)
        

    sortTitans = () ->
        $scope.titans.sort(titanComparer)
        return
    

    updateStatus = (titanid, data) ->
        hashrate = 0
        hashratetimestamp = Date.now()
        $scope.titans = (t for t in $scope.titans when t.id != titanid)
        if data.DEVS?
            for die in data.DEVS
                hashrate += die["MHS 20s"]
            hashrate = parseFloat(hashrate.toFixed(2))
        $scope.titans.push({ id: titanid, hashrate: hashrate, timestamp: hashratetimestamp })
        sortTitans()
        $scope.hashrate = 0
        for t in $scope.titans
            $scope.hashrate += t.hashrate
        $scope.hashrate = parseFloat($scope.hashrate.toFixed(2))
        $scope.hashratetimestamp = Date.now()
        return

    createUpdateFn = (titanid) ->
        return (data) ->
            updateStatus(titanid,data)
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

    

    fetchStatus = () ->
        hosts = [ 'localhost' ]
        hosts = hosts.concat($scope.hosts)
        for host in hosts
            titanid = host
            url = '/cgi-bin/bfgminer_procs.cgi'
            if host != 'localhost'
                url = 'http://' + host + url
            req = {
                url : url
                cache: false
                method: 'GET'
            }
            url = ''
            $http(req).success(createUpdateFn(titanid))
        return

    

    $scope.selectInterval = (interval) ->
        $scope.selectedInterval = interval.time
        return

    $scope.selectStyle = (style) ->
        $rootScope.selectedStyle = style
        return

    $scope.selectInterpolation = (interpolation) ->
        $scope.selectedInterpolation = interpolation.value
        return

    getRandomImage = () ->
        imageCount = 22
        i = Math.floor((Math.random()*imageCount)+1)
        if i < 10
            i = "0" + i
        return "images/minion#{i}.png"

    selectRandomImage = () ->
        $scope.titleimage1 = getRandomImage()
        $scope.titleimage2 = getRandomImage()
        $scope.titleimage3 = getRandomImage()

        return

    loadHostsFromCookie = () ->
        hosts = $cookies.hosts
        if hosts?
            $scope.hosts = JSON.parse(hosts)

    saveHostsToCookie = () ->
        $cookies.hosts = JSON.stringify($scope.hosts)
    
    $scope.addNewHost = () ->
        $scope.hosts.push($scope.newHost)
        $scope.titans.push({ id: $scope.newHost, hashrate: 0, timestamp: Date.now() })
        sortTitans()
        delete $scope.newHost
        saveHostsToCookie()

    $scope.go = (path) ->
        $location.path(path)

    $scope.navigate = (path) ->
        window.location = path

    $scope.removeTitan = (id) ->
        $scope.titans = (t for t in $scope.titans when t.id != id)
        $scope.hosts = (h for h in $scope.hosts when h != id)
        saveHostsToCookie()


    setupValues()
    loadHostsFromCookie()
    fetchStatus()
    $interval(fetchStatus,5000)
    
    selectRandomImage()

    $interval(selectRandomImage,60000)

    return
]