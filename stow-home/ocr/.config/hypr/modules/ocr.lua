hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wl-paste -t image/png | ocr | wl-copy"),
    { description = "Read data from clipboard image" })
