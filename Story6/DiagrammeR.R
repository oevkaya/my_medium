# Creating Diagrams using R 

# Package installing and using 

install.packages("DiagrammeR")
library(DiagrammeR)

# Other necesary packages
library(DiagrammeRsvg) ; library(rsvg) 


# create_graph ------------------------------------------------------------


# First creating from scratch

# define nodes dataframe
nodes <- create_node_df(n = 5, 
                        type = "lower",
                        style = "filled",
                        color = "acqua", 
                        shape = "circle", # Change it rectangle
                        data = c(3.5, 2.6, 9.4, 2.7, 12.4))

# defining the edges dataframe
edges <- create_edge_df(from = c(1, 2, 3, 3, 5),
                        to = c(2, 5, 4, 2, 1))


# create and print the graph
my_graph <- create_graph(nodes_df = nodes, edges_df = edges)
render_graph(my_graph)

# Exporting the figure as an image file (png format below)

export_graph(my_graph, file_name = "SimpleNetwork.png",
             file_type = "PNG")


# graphviz ----------------------------------------------------------------


# Alternatively, create diagrams using Graphviz
# Statistical Learning methods tree

my_graphviz <- grViz("digraph{
         
                     graph[rankdir = TB]
                     
                     node[shape = rectangle, style = empty]  
                     A[label = 'Statistical Learning']
                     B[label = 'Supervised']
                     C[label = 'Unsupervised']
                     D[label = 'Classification']
                     E[label = 'Prediction']
                     F[label = 'Clustering']
                     G[label = 'Association']
                     H[label = 'Dimension Reduction']


                     edge[color = red]
                     A -> B [color = black]
                     A -> C [color = black]
                     B -> D
                     B -> E
                     C -> F
                     C -> G
                     C -> H
                     
                     }")

my_graphviz

# A GraphViz object requires a few more steps to save as an image file:

# export graph
export_svg(my_graphviz) %>%
  charToRaw() %>%
  rsvg() %>%
  png::writePNG("simple_grv.png")

# Consider the same one with DiagrammR function 
# The syntax is a bit different now, by using different shaped nodes

DiagrammeR("graph TB;
    A(Statistical Learning)-->B[Supervised];
    A(Statistical Learning)-->C[UnSupervised];
    B---D{Prediction};
    B---E{Classification};
    C-->F((Clustering));
    C-->G((Association))
    C-->H((Dimension Reduction));")

# Change the direction
# graph LR, RL, BT

# Usage of grViz in a different way, for creating a flowchart, 
# Steps of ML project

grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle, style = filled]        
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']
      tab6 [label = '@@6']

      # edge definitions with the node IDs
      tab1 -> tab2;
      tab2 -> tab3;
      tab3 -> tab4 -> tab5 -> tab6
      }

      [1]: 'Problem Understanding'
      [2]: 'Collect/Extract/Preprocess the Data'
      [3]: 'Main Exploratory Analysis'
      [4]: 'Model Development, Training and Evaluation'
      [5]: 'Perform model diagnostics'
      [6]: 'Model Deployment and Maintenance'

      ")

# mermaid -----------------------------------------------------------------

# Now consider mermaid functionality here
# Not so easy to customize 
# It also not currently possible to export a diagram created in mermaid to a static file

# Life Cycle of a Machine Learning Project

mermaid("
        graph TB
        A[Problem Understanding]
        A --> B[Data Collection]
        B --> C[Data Wrangling]
        C --> D[Model Development, Training and Evaluation]
        D --> E[Model Deployment and Maintenance]
        ")

# with different colors and annotations, with different features

mermaid("
        graph TB
        A[Problem Understanding]
        A-->B[Data Collection]
        B-->C[Data Wrangling]
        C-->|Pre-processing|D[Model Development]
        D-->|Training and Testing|E[Model Deployment and Maintenance]
        
        style A fill:#FFF, stroke:#333, stroke-width:4px
        style B fill:#9AA, stroke:#9AA, stroke-width:3px
        style C fill:#879, stroke:#333, stroke-width:3px
        style D fill:#ADF, stroke:#333, stroke-width:5px
        style E fill:#9C2, stroke:#9C2, stroke-width:4px
        ")

# You can save from Viewer by export
# ganntt chart -------------------------------------------------------------

# DiagrammeR package allows us to create gantt chart as well

mermaid("
gantt
dateFormat  YYYY-MM-DD
title Project Tasks Plan

section Data 
Collection                    :done,          first_1,    2014-01-06, 2014-02-06
Cleaning                :active,        first_2,    2014-01-06, 2w
EDA                           :               first_3,    after first_2, 1w
Fit models                    :               first_4,    after first_3, 2w

section Models
Testing                         :crit, done,    import_1,   2014-01-06, 2w
Performances                    :crit, done,    import_2,   after import_1, 2w
Select the best                 :crit, active,  import_3,   after import_2, 2w

")


# Bonus Part --------------------------------------------------------------


library(dagitty)
library(ggdag)
library(patchwork)

# dag1 <- dagitty("dag{U2 <- U1}")
# tidy_dagitty(dag1) %>% 
# ggdag(dag1, layout = "circle", node_size = 10) +
#   theme_dag_blank()

dag1 <- dagify(U1 ~ U2) %>% 
  ggdag(node_size = 12, text_size = 2.88) + 
  labs(title = "uni-directed") + theme_dag_blank()
#dag1

# dag2 <- dagitty("dag{U2 <-> U1}")
# tidy_dagitty(dag2) %>% 
# ggdag(dag2, layout = "circle", node_size = 10) +
#   theme_dag_blank()

dag2 <- dagify(U1 ~~ U2) %>% 
  ggdag(node_size = 12, text_size = 2.88) + 
  labs(title = "bi-directed") + theme_dag_blank()
#dag2

dag3 <- dagify(U2 ~ U3,
               U2 ~ U1,
               U2 ~ U4,
               U5 ~ U4) %>% ggdag(node_size = 12, text_size = 2.88, 
                                  label_col = "red") + 
  labs(title = "DAG 5-dim") + theme_dag_blank()

dag1 + dag2 + dag3

# Further readings --------------------------------------------------------

# https://datascienceplus.com/how-to-build-a-simple-flowchart-with-r-diagrammer-package/
  
# https://cyberhelp.sesync.org/blog/visualization-with-diagrammeR.html

# https://www.erikigelstrom.com/articles/causal-graphs-in-r-with-diagrammer/

# https://www.graphviz.org/

# http://rich-iannone.github.io/DiagrammeR/index.html

# https://newbedev.com/gantt-charts-with-r

# https://ggdag.malco.io/articles/intro-to-dags.html
  
