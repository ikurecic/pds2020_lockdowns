library(tidyverse)

# deaths are cumulative
deaths_by_date <- "https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv?raw=true" %>%
  read_csv() %>%
  rename(State=Province_State) %>%
  gather('1/22/20':last_col(), key="date", value="deaths") %>%
  group_by(State, date) %>%
  summarise(deaths = sum(deaths)) %>%
  mutate(date = as.Date(date, "%m/%d/%y"))

unemployment <- "r539cy.xls.csv" %>%
  read_csv(col_types = cols_only(State=col_guess(),
                                 "Filed week ended"=col_date("%m/%d/%Y"),
                                 "Initial Claims"=col_guess())) %>%
  rename(date=`Filed week ended`, unemployment_claims=`Initial Claims`)

deaths_and_unemployment <- left_join(deaths_by_date, unemployment) %>%
  fill(unemployment_claims) %>%
  arrange(date, .by_group=TRUE)


policy <- "test3.csv" %>%
  read_csv(col_types = cols("Stay at Home Announced"=col_date("%d-%b-%y"),
                            "Policy Begin"=col_date("%d-%b-%y"),
                            "Policy End"=col_date("%d-%b-%y")))

all_data <- right_join(deaths_and_unemployment, policy) %>%
  mutate(under_lockdown = date >= `Policy Begin` & date < `Policy End`) %>%
  mutate(deaths_in_day=deaths-lag(deaths)) %>%
  mutate(deaths_relative_difference=deaths_in_day/lag(deaths_in_day)) %>%
  write_csv("all_data.csv")

all_data %>%
  select(State,date,deaths,deaths_in_day,deaths_relative_difference,unemployment_claims,Party,Region,Population_Density,Percent_of_GDP,GDP_per_Capita,under_lockdown) %>%
  write_csv("all_useful_data.csv")


