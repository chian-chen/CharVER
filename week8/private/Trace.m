function [newB, Order, Area] = Trace(B, row, col, cases)

    newB = B;
    startRow = row; startCol = col;
    
    points = sum(newB, 'all');
    Order = zeros(points, 2);   num = 1;
    Area = 0;
    currentCase = cases{4};
    
    while points > 0
        
        Order(num, 1) = row;
        Order(num, 2) = col;
        num = num + 1;
        newB(row, col) = 0;
        Area = Area + 1;
        
        window = newB(row - 1: row + 1, col - 1: col + 1);
        points = sum(window, 'all');
        
        % Trace Back
        if(points == 0)
            back = num - 1;
            while points == 0 && back > 1
                back = back - 1;
                row = Order(back, 1);
                col = Order(back, 2);
                window = newB(row - 1: row + 1, col - 1: col + 1);
                points = sum(window, 'all');
                if ((row == startRow && col == startCol))
                    break;
                end
            end
            currentCase = cases{4};
        end

        
        for i = 1 : 8
            if window(currentCase(i)) == 1
                [row, col, c] = Update(row, col, currentCase(i));
                currentCase = cases{c};
                break;
            end
        end
        
        if (row == startRow && col == startCol)
            break;
        end
    end
    
    Order( ~any(Order,2), : ) = [];  %delete all zero rows
end