function an=IntegralImage_HaarY(row, column, size, img)%HaarY方向小波变换
an= IntegralImage_BoxIntegral(row, column - size / 2, size / 2, size , img) - IntegralImage_BoxIntegral(row - size / 2, column - size / 2, size / 2, size , img);

        