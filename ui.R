###############################################################################
###############################################################################
###############################################################################

library(shiny)

###############################################################################

shinyUI(fluidPage(
  
  titlePanel("Moje R pískoviště"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      #########################################################################
      
      ## první záložka
      
      conditionalPanel(
        
        condition = "input.conditionedPanels == 1",
        
        "Do textového pole můžete psát Váš kód:",
        
        tags$style(type = "text/css",
                   "textarea {width:100%}"
                   ),

        tags$textarea(id = "inputted_code",
                      rows = 30,
                      cols = 90,
                      ""),
        
        submitButton(text = "Staň se!",
                     icon = NULL,
                     width = NULL)
        
      ),
      
      
      #########################################################################
      
      ## druhá záložka
      
      conditionalPanel(
          
          condition = "input.conditionedPanels == 2",
          
          h5("O aplikaci.")
          
        
        #########################################################################
        
      ), width = 5
      
    ),
    
    
    ###############################################################################
    
    mainPanel(
      
      tabsetPanel(
        
        #######################################################################
        
        ## první záložka
        
        tabPanel(
          title = "Výstup z R konzole",
          h5("Zde je zobrazen výstup z R konzole:"),
          verbatimTextOutput("executed_code"),
          plotOutput("my_plot_executed_by_code"),
          value = 1
        ),
        
        
        #######################################################################
        
        ## druhá záložka
        
        tabPanel(
          title = "O aplikaci",
          h5("Zde je text o aplikaci."),
          h5("Blah blah blah."),
          value = 2
        ),
        
        
        #######################################################################
        
        id = "conditionedPanels"
        
      ), width = 7
      
    )
  
  )
  
))


###############################################################################
###############################################################################
###############################################################################





