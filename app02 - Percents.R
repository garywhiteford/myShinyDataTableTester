library(shiny)
library(formattable)

# Global values -----------------------------------------------------------
df_data1 <- formattable(data.frame(col_String = c("A","B","C"),
                      col_Numeric = c(1000, 1/3, 1000 + 1/3),
                      col_Integer = as.integer(1001:1003),
                      col_Percent = percent(c(1, 1.25, .33)),
                      stringsAsFactors = FALSE))

df_data2 <- formattable(data.frame(col_String = c("A","B","C"),
                                  col_Numeric = accounting(c(1000, 1/3, 1000 + 1/3)),
                                  col_Integer = accounting(1001:1003, format = "d"),
                                  col_Percent = percent(c(1, 1.25, .33), digits = 1),
                                  stringsAsFactors = FALSE))

server <- function(input, output) {
  output$vrb_out1a <- renderText("df_data1 <- data.frame(col_String = c(\"A\",\"B\",\"C\"),
                      col_Numeric = c(1000, 1/3, 1000 + 1/3),
                      col_Integer = as.integer(1001:1003),
                      col_Percent = percent(c(1, 1.25, .33), digits = 1),
                      stringsAsFactors = FALSE)")
  
  output$vrb_out1b <- renderText("renderFormattable(df_data1)")
  output$vrb_out1c <- renderPrint({str(df_data1)})
  
  output$tbl_out1 <- renderFormattable(df_data1)
  
  output$vrb_out2a <- renderText("df_data2 <- formattable(data.frame(col_String = c(\"A\",\"B\",\"C\"),
                                  col_Numeric = accounting(c(1000, 1/3, 1000 + 1/3)),
                                  col_Integer = accounting(1001:1003, format = \"d\"),
                                  col_Percent = percent(c(1, 1.25, .33), digits = 1),
                                  stringsAsFactors = FALSE))")
  
  output$vrb_out2b <- renderText("renderFormattable(df_data2)")

  output$tbl_out2 <- renderFormattable(df_data2)
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
      p("Note: Simply applying ", em("formattable"), " to the dataframe does not format the numeric vectors. 
        Also, the formattable function ", em("percent()"), " defaults to 2 decimal points."),
      verbatimTextOutput("vrb_out1b"),
      verbatimTextOutput("vrb_out1c"),
      formattableOutput("tbl_out1"),
      h3("Modified sample data..."),
      verbatimTextOutput("vrb_out2a"),
      h3("Sample #4"),
      p("Note: Using the formattable functions ", em("accounting()"), " and ", em("percent()"), " along with some 
         formatting arguments provides the desired results. The format argument takes values that work with the ", 
        em("formatC"), " function (e.g., \"d\" = integer)."),
      verbatimTextOutput("vrb_out2b"),
      formattableOutput("tbl_out2")
    )
  )
)
shinyApp(ui = ui, server = server)