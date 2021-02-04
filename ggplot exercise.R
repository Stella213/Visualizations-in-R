install.packages("ggplot2")
library("ggplot2")

#The basic template of any plot is as follows:
#ggplot(data = <DATA>,
#       mapping = aes(<MAPPING>)) + 
#  <GEOM_FUNCTION>(
#    stat = <STAT>, 
#    position = <POSITION>) +
#  <COORDINATE_FUNCTION> +
#  <FACET_FUNCTION>

# We will use the dataset midwest, which comes in ggplot2

# Mapping: The terms "aesthetic" and "mapping" are used interchngeably, and define the properties 
# of the output in terms of the variables

# Geom_function: Plot type to add to the call

# Examples are geom_histogram, geom_point (for scatterplots), geom_boxplot, geom_line

data(midwest)
ggplot(data = midwest, 
      mapping = aes(x = percbelowpoverty)) +
  geom_histogram()

ggplot(midwest, aes(x = percbelowpoverty)) +
  geom_density()

ggplot(midwest, aes(x = percbelowpoverty, y = perchsd)) + #perchsd is percentage high-school educated
  geom_point()

# You could also put the aes function inside geom_function

ggplot(midwest) + 
  geom_point(aes(x = percbelowpoverty, y = perchsd))

ggplot(midwest, aes(x = percbelowpoverty, y = perchsd)) + #perchsd is percentage high-school educated
  geom_point(aes(color = state))

ggplot(midwest, aes(x = percbelowpoverty, y = perchsd)) + 
  geom_point(aes(color = state)) +
  geom_smooth() #default method is LOESS, which is piece-wise least square fit

ggplot(midwest, aes(x = percbelowpoverty, y = perchsd)) + 
  geom_point(aes(color = state)) +
  geom_smooth(method = 'lm', color='seagreen') # lm refers to best fit linear model

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")

print(gg)

# Scatter plot with encircling

options(scipen = 999) #disable scientific notation
library(ggplot2)

install.packages("ggalt")
library(ggalt)

midwest_select <- midwest[midwest$poptotal > 350000 & 
                            midwest$poptotal <= 500000 & 
                            midwest$area > 0.01 & 
                            midwest$area < 0.1, ]

# Plot
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) +   # draw points
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) +   # draw smoothing line
  geom_encircle(aes(x=area, y=poptotal), 
                data=midwest_select, 
                color="red", 
                size=2, 
                expand=0.08) +   # encircle
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot + Encircle", 
       caption="Source: midwest")

#Plot text and label

gg + geom_text(aes())

# Now let's look at the other arguments in the ggplot function
# We will switch to the mpg dataset in R

data(mpg)
head(mpg)

ggplot(mpg, aes(x = class)) + geom_bar() # geom_bar automatically counts of the number in each class

class_agg <- data.frame(table(mpg$class))
names(class_agg) <- c("class", "count")

ggplot(class_agg, aes(x = class, y = count)) + 
  geom_bar(aes(fill = class), stat = "identity")

# geom_bar automatically counts (i.e., stat="bin" by default), 
# but if you want it to represent values in the data, then use stat="identity"

#Facets create plots per grouping variable

ggplot(midwest, aes(x = percwhite, y = percblack)) + 
  geom_point() + 
  facet_wrap(~ state)

ggplot(mpg) + 
  geom_count(aes(x = hwy, y = cty))

ggplot(mpg) + 
  geom_point(aes(x = hwy, y = cty))

# geom_jitter adds a small amount of random variation to the location of each point

ggplot(mpg) + 
  geom_jitter(aes(x = hwy, y = cty))

ggplot(mpg) + 
  geom_jitter(aes(x = hwy, y = cty)) + 
  facet_grid(class ~ manufacturer)

ggplot(mpg) + 
  geom_jitter(aes(x = hwy, y = cty, color = class, shape = drv, size = cyl)) +
  scale_radius() 
# scale_radius makes the smallest point proportionate with the rest. 
# Try scale_size instead and see how it compares

# load package and data
install.packages("ggExtra")
library(ggExtra)

# Scatterplot
theme_set(theme_bw())  # pre-set the bw theme.
mpg_select <- mpg[mpg$hwy >= 35 & mpg$cty > 27, ]
g <- ggplot(mpg, aes(cty, hwy)) + 
  geom_count() + 
  geom_smooth(method="lm", se=F)

ggMarginal(g, type = "histogram", fill="transparent")
#ggMarginal(g, type = "boxplot", fill="transparent")
ggMarginal(g, type = "density", fill="transparent")

# Animations

install.packages('devtools')
devtools::install_github('thomasp85/gganimate')

library(gganimate)

attach(mtcars)

ggplot(mtcars, aes(factor(cyl), mpg)) + 
  geom_boxplot() + 
  # Here comes the gganimate code
  transition_states(
    gear,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() + 
  exit_shrink() +
  ease_aes('sine-in-out')

install.packages("gapminder")
library(gapminder)

gap_with_colors <-
  data.frame(gapminder,
             cc = I(country_colors[match(gapminder$country,
                                         names(country_colors))]))

get_map(location = "texas", zoom = 6, source = "stamen", api_key = 'AIzaSyC7yreyExuEK6171iMLnP5NKqAXwtx4sUo')

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

# Spatial maps

chennai <-  geocode("Chennai", source = "dsk")  # get longitude and latitude

install.packages("mapsapi")
library(mapsapi)

library(xml2)

doc = mp_directions(
  origin = c(34.81127, 31.89277),
  destination = "Haifa",
  alternatives = TRUE
)

doc = as_xml_document(response_directions_driving)

r = mp_get_routes(doc)
r

install.packages("leaflet")
library(leaflet)

pal = colorFactor(palette = "Dark2", domain = r$alternative_id)
leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addPolylines(data = r, opacity = 1, weight = 7, color = ~pal(alternative_id))

