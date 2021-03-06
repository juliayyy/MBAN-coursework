## Clinic Sunday Operation Simulation Webapp

The project hypothetically constructed a clinic that provides two types of services: eye examination (does not need reservation) and cataract surgery services (needs reservation). Now the clinic operates from Monday to Saturday. To cater to greater market demand, the clinic's manager has been considering Sunday operations.

To facilitate the manager’s decision making, we built this Shiny app, which allows managers to try out different combinations of schedule intervals (mins) and doctor’s hourly salary. The tool will simulate the clinic’s typical day operation and provide the key performance metrics: profit, average waiting time (scheduled and walkins) and doctor’s overtime based on different decisions.

<h4> Packages Required: </h4>

- library(shiny)
- library(ggplot2)
- library(DT)
- library(dplyr)
- library(plotly)

<h4> Components: </h4>

- Clinic Project Shiny Version 1.R
- model_intro.html
- analysis.html

<h4> Webapp Appearance: </h4>

![](sim1.png)
![](sim2.png)
![](sim3.png)