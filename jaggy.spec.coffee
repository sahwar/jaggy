Jaggy= require './'
gulp= require 'gulp'

jasmine.DEFAULT_TIMEOUT_INTERVAL= 10000

describe 'Jaggy',->
  describe 'Standard Usage',->
    it 'Convert to <svg> by .gif',(done)->
      gulp.src 'public_html/*.gif'
        .pipe Jaggy()
        .pipe gulp.dest 'public_html'
        .on 'end',done

    it 'Convert to <svg> by .png',(done)->
      gulp.src 'public_html/*.png'
        .pipe Jaggy()
        .pipe gulp.dest 'public_html'
        .on 'end',done

    it 'Convert to <svg> by .jpg',(done)->
      gulp.src 'public_html/*.jpg'
        .pipe Jaggy()
        .pipe gulp.dest 'public_html'
        .on 'end',->
          done()

    it 'Glitch to <svg> by .png',(done)->
      gulp.src 'public_html/yuno.png'
        .pipe Jaggy glitch:3
        .pipe gulp.dest 'public_html'
        .on 'end',done

    it 'Convert to pixels by gutil.File',(done)->
      gutil= require 'gulp-util'
      path= require 'path'
      fs= require 'fs'

      file= new gutil.File
        cwd: __dirname
        base: "#{__dirname}/public_html/"
        path: "#{__dirname}/public_html/moon.png"
        contents: fs.readFileSync "#{__dirname}/public_html/moon.png"

      Jaggy.readImageData file,(error,pixels)->
        expect(error).toEqual(null)
        expect(pixels.data.length).toEqual(96*192*4)
        expect(JSON.stringify pixels.shape).toEqual('[96,192,4]')

        done()

  describe 'Create Element',->
    it 'Convert to <g> by Frame',->
      frame= new Jaggy.Frame
      expect(frame.toG().outerHTML).toEqual('<g></g>')

    it 'Convert to <path> by Color',->
      color= new Jaggy.Color
      expect(color.toPath('').outerHTML).toEqual('<path></path>')

  describe 'Class',->
    it 'Color has points',->
      color= new Jaggy.Color
      expect(JSON.stringify color).toEqual('{"points":[]}')

    it 'Point is {x,y}',->
      point= new Jaggy.Point 0,0
      expect(JSON.stringify point).toEqual('{"x":0,"y":0}')

    it 'Rect like a Point ',->
      point= new Jaggy.Point 0,0
      rect= new Jaggy.Rect point
      expect(JSON.stringify rect).toMatch((JSON.stringify point).slice(-1))

    it 'Rect is M0,0h1v1h-1Z',->
      rect= new Jaggy.Rect x:0,y:0
      expect(rect.toD()).toEqual('M0,0h1v1h-1Z')