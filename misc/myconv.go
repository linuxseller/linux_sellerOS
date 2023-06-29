package main

import (
    "image"
    "image/png"
    "image/color"
    "log"
    "os"
    "math"
    "encoding/binary"
    "fmt"
    "strings"
)

type ImageData struct {
    img               image.Image
	x0, y0            int
	koffX, koffY      int
	width, height     int
}

type Pair struct {
    a int
    b int
}


var (
	imgFileName         string
    imgHolder           image.Image
	err                 error
    mainImgFileName     string
    mainImgFile         *os.File
)

func main(){
    resultW, resultH := 100, 100
    biosCols := make(map[int]uint32)
    biosCols[0]  = 0x000000ff
    biosCols[1]  = 0x0000aaff
    biosCols[2]  = 0x00aa00ff
    biosCols[3]  = 0x00aaaaff
    biosCols[4]  = 0xaa0000ff
    biosCols[5]  = 0xaa00aaff
    biosCols[6]  = 0xaa5500ff
    biosCols[7]  = 0xaaaaaaff
    biosCols[8]  = 0x555555ff
    biosCols[9]  = 0x5555ffff
    biosCols[10] = 0x55ff55ff
    biosCols[11] = 0x55ffffff
    biosCols[12] = 0xff5555ff
    biosCols[13] = 0xff55ffff
    biosCols[14] = 0xffff55ff
    biosCols[15] = 0xffffffff



    mainImgFileName = os.Args[1]
    mainImgFile, err = os.Open(mainImgFileName)
    if err!=nil {
        log.Panic("Error: no such image %s", mainImgFileName)
    }
    imgHolder, err = png.Decode(mainImgFile)
    if err != nil {
        log.Panic("Error: error parsing image, must be png")
    }
    img := ImageData{imgHolder,
                        imgHolder.Bounds().Min.X, imgHolder.Bounds().Min.Y,
                        imgHolder.Bounds().Max.X/resultW+1, imgHolder.Bounds().Max.Y/resultH+1,
	                    imgHolder.Bounds().Max.X, imgHolder.Bounds().Max.Y,
                    }
    mainImgName := mainImgFileName[strings.IndexByte(mainImgFileName, '/')+1:strings.IndexByte(mainImgFileName, '.')]
    fmt.Printf("%sx: .byte %d\n", mainImgName, img.width/img.koffX)
    fmt.Printf("%sy: .byte %d\n", mainImgName, img.height/img.koffY)
    fmt.Printf("%s_image: .byte ", mainImgName)
    for y:=0; y<img.height-img.koffY; y++ {
        for x:=0; x<img.width-img.koffX; x++ {
            best := Pair{0, 100000}
            clr := colorToUint32(img.img.At(x*img.koffX, y*img.koffY))
            src := make([]byte, 4)
            binary.LittleEndian.PutUint32(src, clr)
            for key, value := range biosCols {
                dst := make([]byte, 4)
                binary.LittleEndian.PutUint32(dst, value)
                result := 30*abs(src[0]-dst[0])+59*abs(src[1]-dst[1])+11*abs(src[2]-dst[2])
                if result<best.b {
                    best.a, best.b = key, result
                }
            }
            fmt.Printf("%d, ", best.a)
        }
    }
    fmt.Println()
}

func colorToUint32(clr color.Color) uint32 {
    var rVal, gVal, bVal uint32
    r,g,b,_ := clr.RGBA()
    rVal += uint32(math.Round(float64(r/256)))
    gVal += uint32(math.Round(float64(g/256)))
    bVal += uint32(math.Round(float64(b/256)))
    rv, gv, bv := uint8(rVal), uint8(gVal), uint8(bVal)
    temp := []uint8{rv,gv,bv,255}
    u32LE := binary.LittleEndian.Uint32(temp)
    return u32LE

}

func abs(a byte) int {
    if a<0 {return int(-a)}
    return int(a)
}
