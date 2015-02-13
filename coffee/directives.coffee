module = angular.module("KncMinionApp.directives", [])

module.directive('ngEnter', () ->
    return (scope, element, attrs) ->
        element.bind("keydown keypress", (event) ->
            if event.which == 13
                scope.$apply(() ->
                    scope.$eval(attrs.ngEnter)
                )
                event.preventDefault()
        )
)

module.directive('d3Graph', ['$window', '$interval', '$timeout', ($window, $interval, $timeout) ->
    return {
        restrict: 'EA'
        scope: {
            value: '='
            counter: '='
        }

        link: (scope, element, attrs) ->

            scope.duration = parseInt(attrs.duration) || 600
            scope.minimum = parseFloat(attrs.minimum) || null
            scope.maximum = parseFloat(attrs.maximum) || null
            scope.plotMinMax = attrs.plotminmax?
            scope.plotCurrent = attrs.plotcurrent?
            
            

            

            scope.lastValueUpdateCounter = 0
            
            scope.data = []
            scope.graphId = Math.floor(Math.random() * 10000000000000001).toString()

            scope.updateData = () ->
                if scope.value? and scope.counter != scope.lastValueUpdateCounter
                    scope.data.push( { value: scope.value || 0, date: new Date() })
                    scope.lastValueUpdateCounter = scope.counter
                
                # Remove all datapoints that are too old
                limit = new Date(Date.now() - (scope.duration+5) * 1000)
                while scope.data[0]?.date < limit
                    scope.data.shift()
            
            scope.setupSize = () ->
                interpolateType = attrs.interpolate || "cardinal"

                scope.width = width = element[0].offsetWidth
                scope.height = height = element[0].offsetHeight

                heightMargin = if scope.plotMinMax then 25 else 5
                rightMargin = if scope.plotCurrent then 50 else 0

                millisecondsPerPixel = (scope.duration * 1000) / (width-rightMargin)
                scope.updatefrequency = Math.max(500, millisecondsPerPixel * 2)

                if scope.updateDataPromise?
                    # Clear old interval
                    $interval.cancel(scope.updateDataPromise)
                scope.updateDataPromise = $interval(scope.updateData,scope.updatefrequency)
                scope.updateData()

                scope.x = d3.time.scale().domain([new Date(Date.now() - scope.duration * 1000), new Date()]).range([0, width - rightMargin])

                scope.y = d3.scale.linear().domain([0,1]).range([height-heightMargin, heightMargin])

                scope.transition_x = scope.x(new Date(Date.now() - scope.updatefrequency)) - scope.x(new Date())

                scope.line = d3.svg.line()
                             .interpolate(interpolateType)
                             .x((d, i) -> return scope.x(d.date))
                             .y((d, i) -> return scope.y(d.value))

                if scope.svg?
                    d3.select(element[0]).selectAll("*").remove();

                
                scope.svg = d3.select(element[0]).append("svg:svg").style({'width':width, 'height': height }).append("g")
                scope.svg.append("defs")
                         .append("clipPath")
                         .attr("id", "clip" + scope.graphId)
                         .append("rect")
                         .attr("width", width)
                         .attr("height", height)

                scope.path = scope.svg.append("g")
                             .attr("clip-path", "url(#clip" + scope.graphId + ")")
                             .append("path")
                             .data([scope.data])
                             .attr("class", "line")
                

            
            scope.setupSize()

            window.onresize = () ->
                scope.setupSize()

            scope.$watch(()->
                return attrs.interpolate
            ,scope.setupSize
            )

            scope.$watch(() ->
                return [angular.element($window)[0].innerWidth,element.is(':visible'),element[0].offsetWidth]
            ,scope.setupSize,true
            )

            scope.tick = () ->
                scope.now = new Date()
                
                # Set new domain for duration
                scope.x.domain([new Date(Date.now() - scope.duration*1000),new Date()])                

                # New domain for the values
                if scope.maximum? and scope.minimum?
                    yextent = [scope.minimum, scope.maximum]
                else
                    yextent = d3.extent(scope.data,(d) -> d.value)
                    if scope.minimum?
                        yextent[0] = scope.minimum
                    if scope.maximum?
                        yextent[1] = scope.maximum
                scope.y.domain(yextent)

                maxValueX = 0
                maxValueY = 0
                minValueX = 0
                minValueY = 0

                scope.svg.selectAll("circle").remove()
                scope.svg.selectAll("text").remove()
                
                if scope.plotMinMax
                    maxValue = Number.MIN_VALUE
                    minValue = Number.MAX_VALUE
                    
                    for p in scope.data
                        if p.value > maxValue and scope.x(p.date) > 0
                            maxValue = p.value
                            maxValueX = scope.x(p.date)
                            maxValueY = scope.y(p.value)
                        if p.value < minValue and scope.x(p.date) > 0
                            minValue = p.value
                            minValueX = scope.x(p.date)
                            minValueY = scope.y(p.value)

                    if maxValue > Number.MIN_VALUE
                        scope.svg.append("circle").attr("cx",maxValueX).attr("cy",maxValueY).attr("r",4).attr("class","graph_max_circle")

                        scope.svg.append("text")
                            .attr("x",maxValueX - 15)
                            .attr("y",maxValueY - 10)
                            .text(maxValue)
                            .attr("class","graph_text_max")

                    if minValue < Number.MAX_VALUE
                        scope.svg.append("circle").attr("cx",minValueX).attr("cy",minValueY).attr("r",4).attr("class","graph_min_circle")
                        scope.svg.append("text")
                            .attr("x",minValueX - 15)
                            .attr("y",minValueY + 20)
                            .text(minValue)
                            .attr("class","graph_text_min")

                if scope.plotCurrent
                    # Plot current
                    lastValue = scope.data[scope.data.length - 1]
                    if lastValue?
                        currentValueX = scope.x(lastValue.date)
                        currentValueY = scope.y(lastValue.value)
                        if currentValueX != maxValueX and currentValueX != minValueX
                            scope.svg.append("circle").attr("cx",currentValueX).attr("cy",currentValueY).attr("r",4).attr("class","graph_current_circle")
                            scope.svg.append("text")
                                .attr("x",currentValueX + 8)
                                .attr("y",currentValueY + 3)
                                .text(lastValue.value)
                                .attr("class","graph_text_current")

                # redraw the line
                scope.svg.select(".line")
                    .attr("d", scope.line)
                    .attr("transform", null)

                doTransition = (x,last = false) ->
                    r = x.transition()
                       .ease("linear")
                       .duration(scope.updatefrequency)
                       .attr("transform", "translate(" + scope.transition_x + ")")
                    if last
                        r.each("end", scope.tick)
    
                doTransition(scope.svg.selectAll("circle"))
                doTransition(scope.svg.selectAll("text"))
                doTransition(scope.path,true)
                
            scope.tick()
            scope.updateData()
          
    }
])