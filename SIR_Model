library(deSolve)

state <- c(S = 999,
           I = 1,
           R = 0)

parameters <- c(B = .9,
                Y = 0.20)

SIR <- function(t, state, parameters)
{
  with(as.list(c(state, parameters)),
  {
    N <- S + I + R
    dS <- -B*(S*I/N)
    dI <- B*(S*I/N) - Y*I
    # dS <- -B*(S*I)
    # dI <- B*(S*I) - Y*I
    dR <- Y*I
    #N <- S + I + R
    list(c(dS, dI, dR))
  })
}

number_of_days <- 40
step_size <- 0.001
times <- seq(0, number_of_days, by = step_size)

out <- ode(y = state, times = times, func = SIR, parms = parameters)
head(out)

out[1,] %>% sum()
out[2,] %>% sum()
out[4000,] %>% sum()


par(oma = c(0, 0, 3, 0))
plot(out, xlab = "Time in Days", ylab = "Number of People")
plot(out[, "S"], out[, "I"], out[, "R"], pch = ".")
mtext(outer = TRUE, side = 3, "SIR model", cex = 1.5)


