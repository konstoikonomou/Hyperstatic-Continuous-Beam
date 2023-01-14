# Hyperstatic-Continuous-Beam-Solution
Program that solves a continuous beam (not interrupted by internal supports), using the method of forces. 
The beam is loaded with a continuous load (q).

INPUT: 
1) hyperstatic grade of the beam
Hyperstatic grade of the continuous beam is equai to the number of openings the beam has minus 1 (hyperstatic_grade = openings - 1)
2) Openings lengths consecutively
3) Continuous load value

OUTPUT: 
xi vector, which is the solution of (dii * xi + diq = 0) linear system xi can then be used to calculate MQN diagrams:
M(of hyperstatic beam at position B) = M(of isostatic prime system at B, because of q load) + M(of system with x1=1 at B) * x1
