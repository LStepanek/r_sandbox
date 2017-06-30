###############################################################################
###############################################################################
###############################################################################

library(shiny)


###############################################################################
###############################################################################
###############################################################################

shinyServer(function(input, output){
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  ## upravuji vložený kód před dalším zpracováním
  
  my_code <- reactive({
    
    unlist(
      lapply(
        strsplit(input$inputted_code, split = "\n")[[1]],
        strsplit,
        split = ";"
        )
      )
    
  })
  
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  ## zavádím helper funkci pro handlování s chybným kódem
  
  isMyCodeCorrect <- function(my_code){
    
    tryCatch(
      
      class(eval(parse(text = my_code))),
      
      warning = function(w){return("Varování nebo chyba!")},
      
      error = function(e){return("Varování nebo chyba!")}
      
    )!="Varování nebo chyba!"
    
  }
  
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  ## vytvářím proměnnou kontrolující, které řádky kódu jsou korektní
  
  is_my_code_correct <- reactive({
    
    ###########################################################################
    
    ## ošetřuji kód; zavádím proměnnou, která pro každý řádek určí, zda je
    ## kód správně
    
    where_is_my_code_correct <- NULL
    
    for(line in my_code()){
      
      where_is_my_code_correct<-c(
        where_is_my_code_correct,
        prod(isMyCodeCorrect(line)) == TRUE
      )
      
    }
    
    return(where_is_my_code_correct)
    
    
    ###########################################################################
    
  })
  
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  ## zkouším zmergovat některé chybné řádky tak, aby mohly být případně
  ## správně zexekuovány
  
  # better_code <- reactive({
  #   
  #   output <- NULL
  #   
  #   i <- 1
  #   
  #   while(i < length(my_code())){
  #     
  #     if(!(i %in% which(is_my_code_correct()))){
  #       
  #       j <- i + 1
  #       new_code_chunk <- paste(my_code()[i], my_code()[i], sep = "")
  #       
  #       while(!isMyCodeCorrect(paste(new_code_chunk, my_code()[j])) &
  #             j <= length(my_code())){
  #         
  #         j <- j + 1
  #         
  #       }
  #       
  #       if(isMyCodeCorrect(new_code_chunk)){
  #         
  #         output <- c(output, new_code_chunk)
  #         i <- j
  #         
  #       }else{
  #         
  #         output <- c(output, my_code()[i])
  #         i <- i + 1
  #         
  #       }
  #       
  #       
  #     }else{
  #       
  #       output <- c(output, my_code()[i])
  #       i <- i +  1
  #       
  #     }
  #     
  #   }
  #   
  # })
  
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  ## vytvářím proměnnou kontrolující, které řádky kódu vedou ke grafickému
  ## výstupu a budou tedy vykresleny v canvasu
  
  will_be_my_code_plotted <- reactive({
    
    ###########################################################################
    
    willBeMyCodePlotted <- function(my_code){
      
      output <- NULL
      
      for(item in ls(getNamespace("graphics"))){
        
        output <- c(output, grepl(item, my_code))
        
      }
      
      return(sum(output) == TRUE)
      
    }
    
    
    ###########################################################################
    
    ## vytvářím proměnnou určující řádky, které budou vykresleny
    
    where_will_be_my_code_plotted <- NULL
    
    for(i in 1:length(my_code())){
      
      where_will_be_my_code_plotted <- c(
        where_will_be_my_code_plotted,
        willBeMyCodePlotted(my_code()[i])
        )
      
    }
    
    return(where_will_be_my_code_plotted)
    
    
    ###########################################################################
    
  })
  
  
  #############################################################################
  
  ## exekuuji kód
  
  output$executed_code <- renderPrint({
    
    ###########################################################################
    
    if(is.null(input$inputted_code)){return(NULL)}
    if(is.null(my_code())){return(NULL)}
    
    
    ###########################################################################
    
    ## vypisuji do konzole relativně solidně ošetřený kód
    
    for(n_row in 1:length(my_code())){
      
      if(!(n_row %in% will_be_my_code_plotted())){
        
        if(n_row %in% which(is_my_code_correct())){
          
          print(eval(parse(text = my_code()[n_row])))
          #eval(parse(text = my_code()[n_row]))
          
        }else{
          
          print(
            tryCatch(
              eval(parse(text = my_code()[n_row])),
              
              warning = function(w){return(
                "Něco není úplně v pořádku. Promyslete svůj kód."
              )},
              
              error = function(e){return(
                "Došlo k maligní chybě! Opravte svůj kód."
              )}
            )
          )
          
        }
        
      }
      
      
    }
    
    
    ###########################################################################
    
    
  })
  
  
  #############################################################################
  #############################################################################
  #############################################################################
  
  output$my_plot_executed_by_code <- renderPlot({
    
    ###########################################################################
    
    if(is.null(input$inputted_code)){return(NULL)}
    if(is.null(my_code())){return(NULL)}
    
    
    ###########################################################################
    
    ## vypisuji do konzole relativně solidně ošetřený kód
    
    for(n_row in 1:length(my_code())){
      
      if(n_row %in% which(is_my_code_correct())){
        
        print(eval(parse(text = my_code()[n_row])))
        
      }else{
        
        print(
          tryCatch(
            eval(parse(text = my_code()[n_row])),
            
            warning = function(w){return(
              "Něco není úplně v pořádku. Promyslete svůj kód."
            )},
            
            error = function(e){return(
              "Došlo k maligní chybě! Opravte svůj kód."
            )}
          )
        )
        
      }
      
    }
    
    
    ###########################################################################
    
    ## zkouším handlovat s grafickým výstupem
    
    
    
    
    ###########################################################################
    
    
  })
  
  
})


###############################################################################
###############################################################################
###############################################################################





