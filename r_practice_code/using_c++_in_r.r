library(Rcpp)

src <- "#include<Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
int timesThree(int a){
  int numberTimesThree = a * 3;
  return numberTimesThree;
}

// [[Rcpp::export]]
std::string returnHello(){
  return \"Hello world\";
}"

sourceCpp(code = src)

timesThree(3)
returnHello()
