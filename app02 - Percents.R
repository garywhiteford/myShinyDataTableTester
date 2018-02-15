library(shiny)
library(formattable)

# Global values -----------------------------------------------------------
df_data1 <- data.frame(col_String = c("A","B","C"),
                       col_Numeric = c(1000, 1/3, 1000 + 1/3),
                       col_Integer = as.integer(1001:1003),
                       col_Percent = percent(c(1, 1.25, .33)),
                       stringsAsFactors = FALSE)

df_data2 <- formattable(data.frame(col_String = c("A","B","C"),
                                  col_Numeric = accounting(c(1000, 1/3, 1000 + 1/3)),
                                  col_Integer = accounting(1001:1003, format = "d"),
                                  col_Percent = percent(c(1, 1.25, .33), digits = 1),
                                  stringsAsFactors = FALSE))

server <- function(input, output) {
  output$vrb_out1a <- renderText("df_data1 <- data.frame(col_String = c(\"A\",\"B\",\"C\"),
                       col_Numeric = c(1000, 1/3, 1000 + 1/3),
                       col_Integer = as.integer(1001:1003),
                       col_Percent = percent(c(1, 1.25, .33)),
                       stringsAsFactors = FALSE)")
  
  output$vrb_out1b <- renderText("renderTable(df_data1) > tableOutput(\"tbl_out1\")")
  output$vrb_out1c <- renderPrint({str(df_data1)})
  
  output$tbl_out1 <- renderTable(df_data1)
  
  output$vrb_out2a <- renderText("df_data2 <- formattable(data.frame(col_String = c(\"A\",\"B\",\"C\"),
                                  col_Numeric = accounting(c(1000, 1/3, 1000 + 1/3)),
                                  col_Integer = accounting(1001:1003, format = \"d\"),
                                  col_Percent = percent(c(1, 1.25, .33), digits = 1),
                                  stringsAsFactors = FALSE))")
  
  output$vrb_out2b <- renderText("renderFormattable(df_data2) > formattableOutput(\"tbl_out2\")")
  output$vrb_out2c1 <- renderText(paste0("str(df_data2$", input$sel_val1, ")"))
  output$vrb_out2c2 <- renderPrint({str(df_data2[[input$sel_val1]])})
  output$vrb_out2d1 <- renderText(paste0("str(as.numeric(df_data2$", input$sel_val1, "))"))
  output$vrb_out2d2 <- renderPrint({str(as.numeric(df_data2[[input$sel_val1]]))})
  
  output$tbl_out2 <- renderFormattable(df_data2)
  
  output$plt_out2 <- renderPlot({
    barplot(as.numeric(df_data2[[input$sel_val1]]), 
            names.arg = df_data2$col_String, 
            main=input$sel_val1,
            ylab="Y axis label (value)",
            xlab="X axis label")
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("FormatTable Test App"),
      p("This app demonstrates functionality of tables and formatting of percentages in Shiny.
        It includes use of the library ", em("formattable"), ".")
    ),
    mainPanel(
      h3("Sample data..."),
      verbatimTextOutput("vrb_out1a"),
      h3("Sample #3"),
      p("Note: The formattable function ", em("percent()"), " does not work with non-formattable render functions."),
      verbatimTextOutput("vrb_out1b"),
      verbatimTextOutput("vrb_out1c"),
      tableOutput("tbl_out1"),
      h3("Modified sample data..."),
      verbatimTextOutput("vrb_out2a"),
      h3("Sample #4"),
      p("Note: Using the formattable functions ", em("accounting()"), " and ", em("percent()"), " along with some 
         formatting arguments provides the desired results. The format argument takes values that work with the ", 
        em("formatC"), " function (e.g., \"d\" = integer). "),
      verbatimTextOutput("vrb_out2b"),
      p("Data in formattable.dataframe may be used in plots, ... "),
      verbatimTextOutput("vrb_out2c1"),
      verbatimTextOutput("vrb_out2c2"),
      p("... but must first be coerced to a vector."),
      verbatimTextOutput("vrb_out2d1"),
      verbatimTextOutput("vrb_out2d2"),
      formattableOutput("tbl_out2"),
      selectInput("sel_val1", label = "Select value set", choices = names(df_data2[2:4])),
      plotOutput("plt_out2")
    )
  )
)
shinyApp(ui = ui, server = server)