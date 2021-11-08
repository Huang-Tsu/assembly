How to run my code:
	在terminal輸入"make"，如果hw3.s存在的話，則會根據makefile中定義的規則，執行 "~/arm-tool-20.4/bin/arm-none-eabi-gcc -g -O0 hw3.s -o hw3.exe"，產生hw3.s的執行檔
	※arm-none-eabi-gcc前的路徑要根據使用者端的檔案位置修改
	執行結束後，輸入"make clean" 執行"rm -rf hw3.exe" 將hw3.exe刪除
Features of my code:
	將main方為四個區段，每個區段compute一個Matrix C的entry，依序為[1,1], [1,2], [2,1], [2,2]
	在每個區段當中，首先將兩個registers初始為該次computation要的row 和 column的起始點，並將一個register初始為0，用來紀錄相對應的row, column相乘的值加總，相對應的元素都相乘完並加總後，將其放到該區段要compute的entry of matrix C
		特別的是，matrix A相乘完後要+4，而matrix要+8，因為matrix A的下一個entry在右邊，而matrix 要相乘的下一個entry在他的下面，中間還隔了一個值，故要+8。

	