
## load required libraries
library(shiny)
library(qpdf)
library(shinythemes)


# Define UI for application that combines PDFs
ui <- fluidPage(theme = shinytheme("cosmo"),

    # Application title
    titlePanel("PDF merger app"),
    
    ## App layout to sidebar
    sidebarLayout(
    
      ## sidebar for selecting the pdf files to merge
    sidebarPanel(ID = "file_input",
                 
                 #file input code for input multiple pdfs
                 fileInput('file', 'Files input', multiple = TRUE, accept =c('.pdf')),
                 
                 #download button for downloading the merged pdfs
                 downloadButton('download', "Download merged pdf files")
    ),
    
    ## main panel for showing which files have been entered.
    mainPanel(ID = 'file_table_out', DT::DTOutput('files')
      
    )
  )
)

# Define server logic required to merge pdfs
server <- function(input, output) {

  ## show which files are uploaded by the user
  output$files <- DT::renderDT({
    ## code to show an error message when no pdf files are uploaded
    validate(
      need(!is.na(input$file), "Please upload pdf files to merge")
    ) 
    
    ## code to produce a table of uploaded files
    DT::datatable(input$file, selection = c("single"),
                  options = list(
                    scrollX = TRUE
                  ))
  })
  
  ## download button for merged pdfs
   output$download <- downloadHandler(
     filename = "merged.pdf",
     content = function(file) {
       # function for combining the pdfs into one file
       qpdf::pdf_combine(input = unique(input$file$datapath), file)
     })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
