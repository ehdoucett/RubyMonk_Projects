# Call Option Price Calculator in Ruby
# calculates the price of an option with two methods (Black-Scholes formula and Monte-Carlo simulation) and compares the results
# used online Ruby editor at https://repl.it/languages/ruby to run the code

# Call(S, t) = N(d_1)*S - N(d_2)*K*exp(-r*(t))
#	S = current price of stock
#	t = time to maturity (years)
#	K = strike price of option
#	r = risk-free interest rate
#	N(x) = cumulative distribution funciton of standard normal distribution
#	d_1 = (log(S/K) + (r + sigma^2/2)*(t))/(sigma*sqrt(t))
#	d_2 = d_1 - sigma*sqrt(t)
#	can verify numbers with http://www.fintools.com/resources/online-calculators/options-calcs/options-calculator/

class CallOption
	attr_reader :s, :k, :r, :t, :sigma
	def initialize(s,k,r,t,sigma)
		# Initialize constants and input parameters
		@RT2PI = Math.sqrt(4.0*Math.acos(0.0))
		@SPLIT = 7.07106781186547
		@N0 = 220.206867912376
		@N1 = 221.213596169931
		@N2 = 112.079291497871
		@N3 = 33.912866078383
		@N4 = 6.37396220353165
		@N5 = 0.700383064443688
		@N6 = 3.52624965998911e-02
		@M0 = 440.413735824752
		@M1 = 793.826512519948
		@M2 = 637.333633378831
		@M3 = 296.564248779674
		@M4 = 86.7807322029461
		@M5 = 16.064177579207
		@M6 = 1.75566716318264
		@M7 = 8.83883476483184e-02
		@U1 = 0.0
		@U2 = 0.0
		@V1 = 0.0
		@V2 = 0.0
		@s = s
		@k = k
		@r = r
		@t = t
		@sigma = sigma
	end

	def N(x)
		# calculate the cumulative normal distribution for given random variable x
		# for x = 0, N(x) = 0.5
		z = x.abs
		c = 0.0
		
		if (z <= 37.0)
			e = Math.exp(-z * z / 2.0)
			if (z < @SPLIT)
				n = (((((@N6*z + @N5)*z + @N4)*z + @N3)*z + @N2)*z + @N1)*z + @N0
				d = ((((((@M7*z + @M6)*z + @M5)*z + @M4)*z + @M3)*z + @M2)*z + @M1)*z + @M0
				c = e * n / d
			else
				f = z + 1.0 / (z + 2.0 / (z + 3.0 / (z + 4.0 / (z + 13.0 / 20.0))))
				c = e / (@RT2PI * f)
			end
		end
		return (x <= 0.0) ? c : 1 - c
	end
	
	def ComputePriceBS
		# calculate d_1 random variable
		d_1 = (Math.log(s / k) + t * (r + sigma**2 / 2.0)) / (sigma * Math.sqrt(t)) 
		
		# calculate d_2 random variable
		d_2 = d_1 - sigma * Math.sqrt(t)
		
		# return the price of the call option with given parameters
		return (s * N(d_1) - k * Math.exp(-r * t) * N(d_2)).round(4)
	end
	
	def Normal_Sample(mean = 0.0, sd = 1.0)
		# finds random sample from Normal distribution for Monte Carlo method
		sample = 0.0
		loop do
			if sample == 0.0 || sample >= 1.0
				@U1 = rand
				@U2 = rand
				@V1 = 2.0 * @U1 - 1.0
				@V2 = 2.0 * @U2 - 1.0
				sample = @V1**2 + @V2**2
			else
				break
			end
		end
		return ((@V1*Math.sqrt(-2.0 * Math.log(sample) / sample)) * sd) + mean
	end
	
	def ComputePriceMC(m, n)
		# calculates price using Monte Carlo simulation with m iterations on n sub-intervals
		m_fl = m.to_f #convert to float for calculations
		n_fl = n.to_f 
		c = 0.0
		m.times do
			price = s 
			n.times do 
				x = Normal_Sample() # get normal sample
				# calculate the price change for the stock
				p = Math.exp((r - sigma**2 / 2.0)*(t / n_fl) + (sigma * Math.sqrt(t / n_fl) * x)) 
				price = price * p
			end
			c = c + [price - k, 0.0].max # calculate call option price and sum up to find average
		end
		c = c * Math.exp(-r * t) / m_fl  # find average price from all m samples
		return c.round(4)
	end
	
	def BestMC(threshold)
		# method to determine reasonable number of MC iterations to use for price of option
		# runs through different values for m, n to find price within price threshold of BS
		bs_price = ComputePriceBS()
		m = 1 # number of iterations
		n = 1 # number of steps for stock price
		mc_price = ComputePriceMC(m, n)
		loop do 
			if (mc_price - bs_price).abs <= threshold || n > 20000
				break # end loop if threshold met or we reach too many samples
			else
				m = m * 2 # increase number of samples
				mc_price = ComputePriceMC(m, n)
				if (mc_price - bs_price).abs <= threshold
					break
				end
				n = n * 2 # increase number of steps for stock price
				mc_price = ComputePriceMC(m, n)
				if (mc_price - bs_price).abs <= threshold
					break
				end
			end
		end
		return ["Black-Scholes price: " << bs_price.to_s, "Monte-Carlo price: " << mc_price.to_s, "Num MC iterations: " << m.to_s, "Num price time steps: " << n.to_s, "Minimum price difference: " << threshold.to_s]
	end

end

# create CallOption object with input parameters
myoption = CallOption.new(100.00,105.00,0.05,1.00,0.20) 

# function to compute the price of the option using Black-Scholes model
puts myoption.ComputePriceBS 

# function to compute price using Monte-Carlo simulation, inputs are (number of samples, number of stock price changes) 
# uses nested loops so large numbers could take awhile
puts myoption.ComputePriceMC(1000,500)

# function to input a maximum price difference between the calculation options and return the number of Monte-Carlo samples needed
# the smaller the price difference threshold the longer this could take, though sometimes it gets lucky
puts myoption.BestMC(0.15)
