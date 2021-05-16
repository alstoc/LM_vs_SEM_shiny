fluidPage(
  uiOutput("study_1_pdfview"),
  tags$script(HTML("iFrameResize({ log: true }, '#pdf_iframe')"))
)

