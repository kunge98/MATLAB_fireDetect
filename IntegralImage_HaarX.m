function an=IntegralImage_HaarX(row, column, size, img)%HaarX����С���任
an= IntegralImage_BoxIntegral(row - size / 2, column, size, size / 2, img) - IntegralImage_BoxIntegral(row - size / 2, column - size / 2, size, size / 2, img);
