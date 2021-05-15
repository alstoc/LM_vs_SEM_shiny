fluidPage(
  uiOutput("theory_pdfview"),
  tags$script(HTML("iFrameResize({ log: true }, '#pdf_iframe')"))
)

