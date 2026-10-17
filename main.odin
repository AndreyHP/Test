package main

import "core:os"
import "core:image/png"
import "core:fmt"
import stbi "vendor:stb/image"

main :: proc() {
    data, err := png.load_from_file("test.png")
    if err != nil {
        fmt.println("Error loading image:", err)
        os.exit(-1)
    }
    defer png.destroy(data)

    // Modify your pixel buffer
    myimg := []u8{0, 255, 255, 255}
    clear_dynamic_array(&data.pixels.buf)
    for pixel in myimg {
        append(&data.pixels.buf, pixel)
    }

    // Ensure width, height, and channels match your image layout
    width := i32(data.width)
    height := i32(data.height)
    channels := i32(data.channels)

    // Save to file using stb_image write
    filename :: "output.png"
    success := stbi.write_png(
        filename,
        width,
        height,
        channels,
        raw_data(data.pixels.buf[:]),
                              width * channels,
    )

    if success == 0 {
        fmt.println("Failed to save PNG file.")
    } else {
        fmt.println("Successfully saved to", filename)
    }
}
