#include "io.h"

int dfs(int x) {
	if(x == 4)
		return 3;
	return dfs(x + 1) + x * x;
}

int main() {
	int ans = 0;
	ans = dfs(1);
	outlln(ans);
	
	return 0;
}