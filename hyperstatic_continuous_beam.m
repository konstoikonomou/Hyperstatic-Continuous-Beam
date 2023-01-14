
% Program that solves a continuous beam (not interrupted by internal
% supports), using the method of forces. 
% The beam is loaded with a continuous load (q).
%
% INPUT: 
% 1) hyperstatic grade of the beam
% Hyperstatic grade of the continuous beam is equai to the number of openings
% the beam has minus 1 (hyperstatic_grade = openings - 1)
% 2) Openings lenghts consecutively
% 3) Continuous load value
%
% OUTPUT: xi vector, which is the solution of (dii * xi + diq = 0) linear system
% xi can then be used to calculate MQN diagrams:
% M(of hyperstatic beam at position B) = M(of isostatic prime system at B,
% because of q load) + M(of system with x1=1 at B) * x1

format bank

hyperstatic_grade = input('\nEnter hyperstatic grade of the continuous hyperstatic beam: ');

if(hyperstatic_grade < 1)
    disp('This method is for hyperstatic beam solution. Grade needs to be >= 1.')
    return
end

if(hyperstatic_grade == 1)
    dimensions = zeros(1, hyperstatic_grade+1);
    f_s = zeros(1, hyperstatic_grade+1);
    for(i=1:hyperstatic_grade+1)
        dimensions(1,i) = input(['Enter opening ' num2str(i) ' length: ']);
    end

    continuous_load = input('Enter continuous load value (kN): ');
    total_length = 0;

    for(i=1:hyperstatic_grade+1)
        total_length = total_length + dimensions(1,i);
    end 

    for(i=1:hyperstatic_grade+1)
        f_s(1,i) = continuous_load * (dimensions(1,i)^2) / 8 ;
    end 

    %total_length

    reaction = (continuous_load * total_length)/2;

    m_at_x1_from_q = reaction * dimensions(1,1) - ...
    (continuous_load * dimensions(1,1) * (dimensions(1,1)/2));

    m_at_x1_from_1 = ((dimensions(1,1) * dimensions(1,2)) / total_length) * (-1);

    d1_1 = 1/3 * total_length * (m_at_x1_from_1)^2;
    d1_q = 1/3 * dimensions(1,1) * m_at_x1_from_1 * m_at_x1_from_q ...
    + 1/3 * dimensions(1,1) * m_at_x1_from_1 * f_s(1,1) ...
    + 1/3 * dimensions(1,2) * m_at_x1_from_1 * m_at_x1_from_q ...
    + 1/3 * dimensions(1,2) * m_at_x1_from_1 * f_s(1,2);

    x1 = -d1_q / d1_1;   % d1_q + (x1 * d1_1) = 0
    
    result_x1 = x1
    fprintf('______________________________\n')
    
    fprintf('At x = 0 , M·(0) = 0.\n') % Interpunct refers to the hyperstatic beam
    
    fprintf('At x = %.3f , M·(%.3f) = %.3f with parabolic arrow %.3f.\n', ...
    dimensions(1,1), dimensions(1,1), (result_x1 * m_at_x1_from_1 + m_at_x1_from_q), f_s(1,1)) 

    fprintf('At x = %.3f , M·(%.3f) = 0 with parabolic arrow %.3f.\n', ...
    total_length, total_length, f_s(1,2))
end

if(hyperstatic_grade > 1)
    dimensions = zeros(1, hyperstatic_grade+1);
    f_s = zeros(1, hyperstatic_grade+1);
    for(i=1:hyperstatic_grade+1)
        dimensions(1,i) = input(['Enter opening ' num2str(i) ' length: ']);
    end

    continuous_load = input('Enter continuous load value (kN): ');
    total_length = 0;

    for(i=1:hyperstatic_grade+1)
        total_length = total_length + dimensions(1,i);
    end 

    for(i=1:hyperstatic_grade+1)
        f_s(1,i) = continuous_load * (dimensions(1,i)^2) / 8 ;
    end 

    di_q = zeros(hyperstatic_grade, 1);
    d_s = zeros(hyperstatic_grade , hyperstatic_grade);

    for(i=1:hyperstatic_grade)
        di_q(i,1) = 1/3 * dimensions(1,i) * f_s(1,i) * 1 + 1/3 * dimensions(1,i+1) * f_s(1,i+1) * 1;
    end

    for(i=1:hyperstatic_grade)
        d_s(i,i) = 1/3 * dimensions(1,i) * 1 * 1 + 1/3 * dimensions(1,i+1) * 1*1;
        
        j = i + 1;

        while (j<= hyperstatic_grade)
            if(j == i + 1)
                d_s(i,j) = 1/6 * dimensions(1, i+1) * 1 * 1;
                d_s(j,i) = d_s(i,j);
            else
                d_s(i,j) = 0;
                d_s(j,i) = d_s(i,j);
            end
            j = j + 1;
        end
    end

    left_matrix = d_s
    right_matrix = - di_q
    result_x = left_matrix \ right_matrix   % di_q + (xI * di_i) = 0
    fprintf('______________________________\n')
    
    fprintf('At x = 0 , M·(0)= 0.\n') % Interpunct refers to the hyperstatic beam
    current_dimension = 0;
    for(i=1:hyperstatic_grade)
        current_dimension = current_dimension + dimensions(1,i);
        fprintf('At x = %.3f , M·(%.3f) = %.3f with parabolic arrow %.3f.\n', ...
        current_dimension, current_dimension, result_x(i,1), f_s(1,i)) 
    end

    fprintf('At x = %.3f , M·(%.3f)= 0 with parabolic arrow %.3f.\n', total_length, total_length ...
    , f_s(1,i+1))
end

fprintf('______________________________\n')  

