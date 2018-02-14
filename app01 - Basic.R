library(shiny)

# Global values -----------------------------------------------------------
df_data <- data.frame(col_String = c("A","B","C"),
                      col_Numeric = c(1000, 1/3, 1000 + 1/3),
                      col_Integer = as.integer(1001:1003))

server <- function(input, output) {
  output$vrb_out1 <- renderText("df_data <- data.frame(col_String = c(\"A\",\"B\",\"C\"),
                      col_Numeric = c(1000, 1/3, 1000 + 1/3),
                      col_Integer = as.integer(1001:1003))")
  
  output$vrb_out2 <- renderText("renderTable(df_data)")

  output$tbl_out1 <- renderTable(df_data)
  
  output$vrb_out3 <- renderText("output$tbl_out2 <- renderTable({df_data},
                               format.args = list(big.mark = \",\"))")
  
  output$tbl_out2 <- renderTable({df_data},
                                 format.args = list(big.mark = ","))
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Basic DataTable Test App"),
      p("This app demonstrates basic functionality of tables and formatting in Shiny.")
    ),
    mainPanel(
      h3("Sample data..."),
      verbatimTextOutput("vrb_out1"),
      h3("Sample #1"),
      p("Note: Default alignment for strings is left and for numbers is right. 
         Default number of digits for integers is 0 and for non-integers is 2."),
      verbatimTextOutput("vrb_out2"),
      tableOutput("tbl_out1"),
      h3("Sample #2"),
      p("Note: Use of format arguments does not change alignment or number of digits."),
      verbatimTextOutput("vrb_out3"),
      tableOutput("tbl_out2")
    )
  )
)
shinyApp(ui = ui, server = server)