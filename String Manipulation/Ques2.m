
function mean_real_val = avg_real(varargin)

	rn= real([varargin{:}]);
	im=imag([varargin{:}]);
	mean_real_val = mean (rn)
  
  output = '';

endfunction

#avg_real(8 +3i, 6 +7i, 4 +3i, 7 + 4i)