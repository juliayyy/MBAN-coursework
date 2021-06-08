#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Do not Delete above

### Part1: Library Load & Install ###
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(plotly)

### Part2: Fixed Parameters Input ###
over_time = 1.5 # Since 10 hours regular working time approaches the upper limit that a doctor can endure, for every extra one minute overtime, the clinic would pool a 1.5hour leave-with-pay for the doctor per clinic policy.
schedule_cost = 5000 # Every schedule client spend 1500 for surgery
wi_cost = 500 # Every walk-in client spend 200 for eye optical exam
wi_interval = 120 # Walk-in arrives following a exponential distribution, with mean of 120 minutes
reps = 1000

### Part3: Functions  ###
### Total 5 Functions are included ###

### Function 1: sim(arrivalTime, serviceTime, wi_arrivalTime, wi_serviceTime,doctor.sal). 
### This function takes in 4 randomly generated vectors and a number; returns a list of 9 objects.
### The major purpose of the function is to simulate the waiting time / leaving time of each customer on a single operation day, 
### based on the arrivalTime, serviceTime of both scheduled clients and walkin clients.

sim <- function(arrivalTime, serviceTime, wi_arrivalTime, wi_serviceTime,doctor.sal){
    daily_schedual <- length(arrivalTime)
    
    waitingTime <- rep(NA, daily_schedual)
    leavingTime <- rep(NA, daily_schedual)
    
    num_wi = length(wi_arrivalTime)
    
    wi_waitingTime <- rep(NA, length(num_wi))
    wi_leavingTime <- rep(NA, length(num_wi))
    
    waitingTime[1] <- 0
    leavingTime[1] <- arrivalTime[1] + waitingTime[1] + serviceTime[1]
    wi_handle = 0
    profit = 0
    
    if (num_wi == 0){
        wi_waitingTime <- c(0)
        wi_leavingTime <- c(0)
    }
    
    for (i in 2:daily_schedual){ # loop all daily_scheduled clients
        if (leavingTime[i - 1] - arrivalTime[i] >= 0){ # the scenario that the next scheduled client arrived before the previous left 
            waitingTime[i] <- leavingTime[i - 1] - arrivalTime[i]
            leavingTime[i] <- arrivalTime[i] + waitingTime[i] + serviceTime[i]
            }
        else if (wi_arrivalTime[wi_handle+1] < arrivalTime[i] && (wi_handle < num_wi)){# the scenario that the next scheduled not arrived before the previous left and there is walkin waiting
            wi_handle = wi_handle + 1
            wi_waitingTime[wi_handle] = max((leavingTime[i-1] - wi_arrivalTime[wi_handle]),0)
            wi_leavingTime[wi_handle] =  wi_arrivalTime[wi_handle] + wi_waitingTime[wi_handle] +wi_serviceTime[wi_handle]
            waitingTime[i] <- max(max(leavingTime[i - 1], wi_leavingTime[wi_handle]) - arrivalTime[i],0)
            leavingTime[i] <- arrivalTime[i] + waitingTime[i] + serviceTime[i]
        }
        else { # the scenario that the next scheduled client not arrived before the previous left, but no walkin waiting
            waitingTime[i] <- max(leavingTime[i - 1] - arrivalTime[i],0)
            leavingTime[i] <- arrivalTime[i] + waitingTime[i] + serviceTime[i]
        }}
    
    if (wi_handle < num_wi) { # after all scheduled clients are dealt, if there are walkins not dealt, doctor start to deal the first left-overt walkin
        wi_waitingTime[wi_handle+1] = max(leavingTime[daily_schedual] - wi_arrivalTime[wi_handle+1],0)
        wi_leavingTime[wi_handle+1] =  wi_arrivalTime[wi_handle+1] + wi_waitingTime[wi_handle+1] + wi_serviceTime[wi_handle+1]
        wi_handle = wi_handle+1
        if (wi_handle < num_wi) {# if there are still walkin left, doctor will continue
            gap = num_wi-wi_handle
            for (i in 1: gap){
                wi_handle = wi_handle+1
                wi_waitingTime[wi_handle] = max(wi_leavingTime[wi_handle-1]-wi_arrivalTime[wi_handle],0)
                wi_leavingTime[wi_handle] =  wi_arrivalTime[wi_handle] + wi_waitingTime[wi_handle] +wi_serviceTime[wi_handle]
            }
            
        }
    }
    
    if (num_wi != 0) # Doctor salary calculation if there are walk-in clients
    {doc_salary = min(600,max(tail(wi_leavingTime,1),tail(leavingTime,1)))/60*doctor.sal + max(0,max(tail(wi_leavingTime,1),tail(leavingTime,1))-600)*over_time*doctor.sal
    total_revenue = num_wi*wi_cost + schedule_cost*daily_schedual
    profit = total_revenue-doc_salary
    }
    else # # Doctor salary calculation if there is no walk-in clients
    { doc_salary = min(tail(leavingTime,1), 600)/60*doctor.sal + max(tail(leavingTime,1)-600, 0)*doctor.sal*over_time
    total_revenue = schedule_cost*daily_schedual
    profit = total_revenue-doc_salary 
    }
    
    return(list(  'num_wi' = num_wi, 
                  'wi_ar' = wi_arrivalTime,  
                  'wi_wt' = wi_waitingTime, 
                  'lv_wi' = wi_leavingTime,
                  'num_sch' = daily_schedual,
                  'ar' = arrivalTime, 
                  'wt' = waitingTime,
                  'lv' = leavingTime, 
                  'profit' = profit) )
}


### Function 2: repsim (doctor.sal,schedule_interval). 
### This function takes in 2 numbers; returns a list of 9 objects.
### The major purpose of the function is to simulate the waiting time / leaving time 1000(reps) times
### based on the manual input of doctor hourly salary and schedule client intervals.

repsim <- function(doctor.sal,schedule_interval){
    simWaitingTimes <- list()
    daily_schedual = 600/schedule_interval
    mean_serviceTime = (200-8*(doctor.sal**0.5))/4# assumed relation
    mean_walk_in_service_time = (200-8*(doctor.sal**0.5))/8 # assumed relation
    
    for (i in 1:reps){
        arrivalTime <- cumsum(rgamma(daily_schedual, schedule_interval,1))
        serviceTime <- rgamma(daily_schedual, mean_serviceTime,1)
        wi = cumsum(rexp(24,1/wi_interval)) 
        wi_arrivalTime = wi[wi<=480] # no walk-in comes after 6:00 pm。
        wi_num = length(wi_arrivalTime)
        wi_serviceTime = rgamma(wi_num, mean_walk_in_service_time,1)
        result = sim(arrivalTime, serviceTime,wi_arrivalTime,wi_serviceTime,doctor.sal)
        simWaitingTimes$wt[i] <- list(result$wt)
        simWaitingTimes$wi_wt[i] <- list(result$wi_wt)
        simWaitingTimes$num_wi[i] <- result$num_wi
        simWaitingTimes$num_sch[i] <- result$num_sch
        simWaitingTimes$wi_ar[i] <- list(result$wi_ar)
        simWaitingTimes$lv[i] <- list(result$lv)
        simWaitingTimes$lv_wi[i] <- list(result$lv_wi)
        simWaitingTimes$profit[i] <- result$profit
        simWaitingTimes$ar[i] <- list(result$ar)
        
    }
    
    return(simWaitingTimes)
}

### Function 3: df_func1 (sim_res). 
### This function takes in 1 list of 9 objects generated from function 2; returns a dataframe containing key simulation results.
### The major purpose of the function is to organize simulation results in a 6*1000 dataframe for plot

df_func1 <- function(sim_res){
    res_df <- data.frame(matrix(ncol = 6, nrow = 0)) # initialize with an empty dataframe
    for (i in 1:reps){
        trial_stat = c(sim_res$num_wi[i],sim_res$num_sch[i], mean(unlist(sim_res$wi_wt[i])),mean(unlist(sim_res$wt[i])),max((max(tail(unlist(sim_res$lv[i]),1),tail(unlist(sim_res$lv_wi[i]),1)))-600,0),sim_res$profit[i])
        res_df = rbind(res_df,trial_stat)
    }
    colnames(res_df)<-c('No_Walkin','No_Schedual','Avg_Wait_Walkin','Avg_Wait_Schedual','Over_time_Mins','Profit')
    return (res_df)
}

### Function 3: df_func2 (sim_res). 
### This function takes in 1 list of 9 objects generated from function 2; returns a dataframe containing how many clients are in the system at a certain time point for 1000 simulations.
### The major purpose of the function is to organize simulation results in a 20*1000 dataframe for plot

df_func2 <- function(sim_res){
    s = seq(30,600,30) # set up a vector representing every 30 mins
    df <- data.frame(matrix(ncol = 20, nrow = 0)) # initialize with an empty dataframe
    
    for (g in 1:reps){
        queue_len = rep(0,20)
        for (i in 1:20){
            for (n in 1: length(unlist(sim_res$ar[g]))){
                if (unlist(sim_res$ar[g])[n]<= s[i] & unlist(sim_res$lv[g])[n]>= s[i]){
                    queue_len[i] = queue_len[i] +1
                }
            }
            if (length(unlist(sim_res$wi_ar[g])) != 0){
                for (n in 1: length(unlist(sim_res$wi_ar[g]))){
                    if (unlist(sim_res$wi_ar[g])[n]<= s[i] & unlist(sim_res$lv_wi[g])[n]>= s[i]){
                        queue_len[i] = queue_len[i] +1  
                    }
                }
            }
        }
        df = rbind(df,queue_len)
    }
    colnames(df)<-c("1030","1100","1130","1200","1230","1300","1330","1400","1430","1500","1530","1600","1630","1700","1730","1800","1830","1900","1930","2000")
    
    return(df)
}

### Function 5: confidence_interval (vector, interval)
### This function takes in a vector and a float; returns a float representing the error of the mean
### The major purpose of the function is to calculate errors of the means (of key performance data from function 3) of 1000 simulations


confidence_interval <- function(vector, interval) {
    # Standard deviation of sample
    vec_sd <- sd(vector)
    # Sample size
    n <- length(vector)
    # Mean of sample
    vec_mean <- mean(vector)
    # Error according to t distribution
    error <- qt((interval + 1)/2, df = n - 1) * vec_sd / sqrt(n)
    # Confidence interval as a vector
    return(error)
}

################################################################################
# Part 4: 
# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Clinic Sunday Operation Simulation"),
          tabsetPanel(
            tabPanel("Introduction & Model",
                     includeHTML("model_intro.html")),
                     
            tabPanel("Simulation",
                     h4("A Single Day Operation Simulation"),
                     p("You can choose any schedule interval & salary combinition below to simulate the KPIs of a single day operation."),
                     p("It may take 2 minutes to initialize, please be patient :) "),
                     hr(),
                     sliderInput("Schedual_Inverval","Schedual Inverval (mins):",min = 20,max = 60,value = 30,step = 5),
                     sliderInput("Salary","Doctor's Hourly Salary ($):",min = 60,max = 140,value = 80,step = 20),
                     fluidRow(column(3, 
                                     h4("Avg Profit")
                     ),
                     column(3,
                            h4("Avg WaitTime-Scheduled")
                     ),
                     column(3,
                            h4("Avg WaitTime-Walkin")
                     ),
                     column(3, 
                            h4("Avg Doctor Overtime")
                     )),
                     fluidRow(
                         column(3, 
                                wellPanel (
                                    div(textOutput("profit"),style = "font-size:100%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(textOutput("wt_s"),style = "font-size:100%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(textOutput("wt_wi"),style = "font-size:100%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(textOutput("ot"),style = "font-size:100%")
                                )
                         )),
                     fluidRow(
                         column(6, 
                                plotOutput("distPlot1", height = 200, width = 400)
                         ),
                         column(6,
                                plotOutput("distPlot2",height = 200, width = 400)
                         )),
                     fluidRow(
                         column(6,
                                plotOutput("distPlot3",height = 200, width = 400)
                         ),
                         column(6,
                                plotOutput("distPlot4", height = 200, width = 400)
                         )),
                     
                     fluidRow(
                         column(12, 
                                plotOutput("distPlot5")
                     )),
                     p("Simulation Result Table"),
                     DT::dataTableOutput("table1")),
            
            tabPanel("All Combinations", 
                     h4("Result of 1000 replications all 45 combinations"),
                     p("Each point on the plot represents a decision combination (salary + interval), the size represents the over_time length, The plot of result analysis shows the relationship between x = average wait time (scheduled) and y = profit"),
                     p("It may take 2 minutes to initialize, please be patient :) "),
                     hr(),
                     h4("Result Plot:"),
                     fluidRow(
                         column(12,
                                plotlyOutput("plot_7",height = 400, width = 800)
                         )),
                     h4("You can type in the conditions to filter the row index of corresponding combinations:"),

                     fluidRow(
                         column(3, 
                                wellPanel (
                                    div(numericInput("Pro", "Profit>:", 1, min = 1, max = 1000000),style = "font-size:80%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(numericInput("wt_sch", "Avg WaitingTime Schedule<:", 10000, min = 1, max = 10000),style = "font-size:80%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(numericInput("wt_wi", "Avg WaitingTime WI<:", 10000, min = 1, max = 10000),style = "font-size:80%")
                                )
                         ),
                         column(3, 
                                wellPanel (
                                    div(numericInput("ot", "Avg Overtime<:", 10000, min = 1, max = 100),style = "font-size:80%")
                                )
                         )),
                     
                     p("Row Index of the most valuable Parameter Combinitions:"),
                     
                     fluidRow(
                         column(12,
                                textOutput("index")
                         )),
                     hr(),
                     DT::dataTableOutput("all"),
                     h4("Sensitivity Plot:"), 
                     fluidRow(
                         column(6,
                                plotOutput("senPlot1",height = 300, width = 400)
                         ),
                         column(6,
                                plotOutput("senPlot2",height = 300, width = 400)
                         )),
                     fluidRow(
                         column(6,
                                plotOutput("senPlot3",height = 300, width = 400)
                         ),
                         column(6,
                                plotOutput("senPlot4",height = 300, width = 400)
                         )),
                     fluidRow(
                         column(6,
                                plotOutput("senPlot5",height = 300, width = 400)
                         ),
                         column(6,
                                plotOutput("senPlot6",height = 300, width = 400)
                         ))
                     ),
            
 
            tabPanel("Analysis",
                      includeHTML("analysis.html")),

            tabPanel("About the Project",
                     h4("Contact"),
                     p("Julia Yuxiao Yang"),
                     p("julia.yuxiao.yang@outlook.com"),
                     hr(),
                     h4("File Components:"),
                     p("Clinic Project Shiny Version 1.R"),
                     p("model_intro.html"),
                     p("analysis.html"),
                     hr())
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {
    set.seed(1)
    mdf1 = reactive({df_func1(repsim(input$Salary,input$Schedual_Inverval))})
    mdf2 = reactive({df_func2(repsim(input$Salary,input$Schedual_Inverval))})
    trail_df <- data.frame(matrix(ncol = 6, nrow = 0))
    sal_vec = seq(60,150,20)
    sal_vec
    interv_vec = seq(20,60,5)
    interv_vec
    for (sal in sal_vec){
        for (int in interv_vec){
            temp_df = df_func1(repsim(sal,int))
            rec_vect = c(sal,int, mean(temp_df$Avg_Wait_Walkin),  mean(temp_df$Avg_Wait_Schedual), mean(temp_df$Over_time_Mins), mean(temp_df$Profit))
            trail_df = rbind(trail_df, rec_vect)
        }
    }
    colnames(trail_df)<-c('Salary','Interval','Avg_Wait_Walkin','Avg_Wait_Schedual','Over_time_Mins','Profit')

    output$distPlot1 <- renderPlot({
        # Profit
        x    <- mdf1()
        ggplot(x, aes(x = x[,6]))  + geom_histogram(bins = 20, color="darkblue", fill="lightblue") + labs(x = "Clinic Profit ($) ", y = "Count", title = 'Clinic Profit Simulation Histogram')
        
    })
    
    output$distPlot2 <- renderPlot({
        # Average Waiting Time - Scheduled
        x    <- mdf1()
        ggplot(x, aes(x = x[,4]))  + geom_histogram(bins = 20, color="darkblue", fill="lightblue") + labs(x = "Average Waiting Time - Scheduled Clients (mins) ", y = "Count", title = 'Average Waiting Time - Schedualed Clients Histogram')
        
    })
    
    output$distPlot3 <- renderPlot({
        # Average Waiting Time - Walkin
        x    <- mdf1()
        ggplot(x, aes(x = x[,3]))  + geom_histogram(bins = 20, color="darkblue", fill="lightblue") + labs(x = "Average Waiting Time - Walkin Clients (mins) ", y = "Count", title = 'Average Waiting Time - Walk-in Clients Histogram')
    })
    
    output$distPlot4 <- renderPlot({
        # Doctor Overtime
        x    <- mdf1()
        ggplot(x, aes(x = x[,5]))  + geom_histogram(bins = 20, color="darkblue", fill="lightblue") + labs(x = "Doctor Overtime (mins) ", y = "Count", title = 'Doctor Overtime Histogram')
    })
    
    output$distPlot5 <- renderPlot({
        # Pipeline
        average_row     <- round(colMeans(mdf2()),0)
        barplot(round(average_row,0),density=20, angle=10 , col="lightblue", xlab = 'Time Points of a Day', ylab = 'number of people in the system', main = 'Average No. of People in the Clinic', ylim = c(0,15) )
    })  
    
 #   max_row = colMeans(df[which.max(rowMeans(df)),])    colMeans(mdf2()[which.max(rowMeans(mdf2())),])
 #   min_row = colMeans(df[which.min(rowMeans(df)),])
 #   average_row = round(colMeans(df),0)
    
    
    output$table1<-  renderDT({
            DT::datatable(mdf1(),editable = TRUE, options = list(paging = TRUE, searching = FALSE, ordering = FALSE, info = FALSE)) %>%
            formatRound(columns=c(3:6), digits=2) %>% formatStyle(columns=c(1:6), textAlign = 'center')
        })
    
    output$profit <- renderText({
        #Average profit
        paste(round(mean(mdf1()$Profit),2),'+/-',round(confidence_interval(mdf1()$Profit,0.95),2))})
    
    output$wt_s <- renderText({
        #Average Waiting time scheduled
        paste(round(mean(mdf1()$Avg_Wait_Schedual),2),'+/-',round(confidence_interval(mdf1()$Avg_Wait_Schedual,0.95),2))})
    
    output$wt_wi <- renderText({
        #Average Waiting time scheduled
        paste(round(mean(mdf1()$Avg_Wait_Walkin),2),'+/-',round(confidence_interval(mdf1()$Avg_Wait_Walkin,0.95),2))})
    
    output$ot <- renderText({
        #Average Doctor Overtime
        paste(round(mean(mdf1()$Over_time_Mins),2),'+/-',round(confidence_interval(mdf1()$Over_time_Mins,0.95),2))})

    output$all <- renderDT({
        # dataframe for all combination simulation - Analysis Tab
        DT::datatable(trail_df,editable = TRUE, options = list(paging = TRUE, searching = FALSE, ordering = FALSE, info = FALSE)) %>%
            formatRound(columns=c(3:6), digits=2) %>% formatStyle(columns=c(1:6), textAlign = 'center')
    })
    
    output$plot_7<- plotly::renderPlotly({
        # Plot for all combination simulation - Analysis Tab
        plot_ly(
            trail_df, x = ~Avg_Wait_Schedual, y = ~Profit,
            # Hover text:
            text = ~paste("Salary: ", Salary, '<br>Interval:', Interval, '<br>Profit:', round(Profit,2), '<br>Avg_Wait_Schedule:', round(Avg_Wait_Schedual,2),'<br>Avg_Wait_Walkin:',round(Avg_Wait_Walkin,2), '<br>Over_time_Mins:',round(Over_time_Mins,2)),
            type   = 'scatter', 
            size = ~Over_time_Mins,
            mode   = 'markers',
            fill = ~'',
            marker = list(sizemode = 'diameter')
        )
    })
    
    output$index <- renderText({which(trail_df$Profit>input$Pro  & trail_df$Over_time_Mins<input$ot & trail_df$Avg_Wait_Schedual < input$wt_sch & trail_df$Avg_Wait_Walkin < input$wt_wi)})
    
    output$senPlot1 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Salary, y=Profit, col = Interval)) + 
            geom_point()
    })  
    
    output$senPlot2 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Interval, y=Profit, col = Salary)) + 
            geom_point()
    })  
    
    output$senPlot3 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Salary, y=Avg_Wait_Schedual, col = Interval)) + 
            geom_point()
    })  
    
    output$senPlot4 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Interval, y=Avg_Wait_Schedual, col = Salary)) + 
            geom_point()
    })  
    
    output$senPlot5 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Salary, y=Over_time_Mins, col = Interval)) + 
            geom_point()
    })  
    
    output$senPlot6 <- renderPlot({
        # Plot for all combination simulation - Analysis Tab
        ggplot(trail_df, aes(x=Interval, y=Over_time_Mins, col = Salary)) + 
            geom_point()
    })  
    
    }


# Run the application 
shinyApp(ui = ui, server = server)
