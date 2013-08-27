
$ ->

  waitForMap ->
    @map = new ymaps.Map($("#map")[0], {center: [55.7990, 37.54527], zoom: 15})

    balloonLayout = ymaps.templateLayoutFactory.createClass('$[properties.content]')
    ymaps.layout.storage.add('place#balloonLayout', balloonLayout)

    placemark = new ymaps.Placemark(
      [55.798154, 37.54527],
    {
      content: $("#balloon-template").html()
    },
    {
      balloonAutoPan: false,
      hideIconOnBalloonOpen: true,
      balloonShadow: false,
      balloonLayout: "place#balloonLayout",
      iconImageSize: [32, 32],
      iconImageOffset: [-20, -30]
    }
    )

    @map.geoObjects.add placemark

    placemark.balloon.open()



window.waitForMap = (callback) ->
  if ymaps.Map
    callback(this)
  else
    setTimeout(
      ->
        waitForMap(callback)
      500
    )