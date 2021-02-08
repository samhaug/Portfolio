/*--------------------------------------------------*/
void finddeps(depth, dep1, dep2)

float depth;
int *dep1;
int *dep2;
{

if (depth <=  25.) {
   *dep1 =   0; *dep2 =  25; goto cont;
}
if (depth <=  50.) {
   *dep1 =  25; *dep2 =  50; goto cont;
}
if (depth <=  75.) {
   *dep1 =  50; *dep2 =  75; goto cont;
}
if (depth <= 100.) {
   *dep1 =  75; *dep2 = 100; goto cont;
}
if (depth <= 125.) {
   *dep1 = 100; *dep2 = 125; goto cont;
}
if (depth <= 150.) {
   *dep1 = 125; *dep2 = 150; goto cont;
}
if (depth <= 175.) {
   *dep1 = 150; *dep2 = 175; goto cont;
}
if (depth <= 200.) {
   *dep1 = 175; *dep2 = 200; goto cont;
}
if (depth <= 225.) {
   *dep1 = 200; *dep2 = 225; goto cont;
}
if (depth <= 250.) {
   *dep1 = 225; *dep2 = 250; goto cont;
}
if (depth <= 275.) {
   *dep1 = 250; *dep2 = 275; goto cont;
}
if (depth <= 300.) {
   *dep1 = 275; *dep2 = 300; goto cont;
}
if (depth <= 325.) {
   *dep1 = 300; *dep2 = 325; goto cont;
}
if (depth <= 350.) {
   *dep1 = 325; *dep2 = 350; goto cont;
}
if (depth <= 375.) {
   *dep1 = 350; *dep2 = 375; goto cont;
}
if (depth <= 400.) {
   *dep1 = 375; *dep2 = 400; goto cont;
}
if (depth <= 425.) {
   *dep1 = 400; *dep2 = 425; goto cont;
}
if (depth <= 450.) {
   *dep1 = 425; *dep2 = 450; goto cont;
}
if (depth <= 475.) {
   *dep1 = 450; *dep2 = 475; goto cont;
}
if (depth <= 500.) {
   *dep1 = 475; *dep2 = 500; goto cont;
}
if (depth <= 525.) {
   *dep1 = 500; *dep2 = 525; goto cont;
}
if (depth <= 550.) {
   *dep1 = 525; *dep2 = 550; goto cont;
}
if (depth <= 575.) {
   *dep1 = 550; *dep2 = 575; goto cont;
}
if (depth <= 600.) {
   *dep1 = 575; *dep2 = 600; goto cont;
}
if (depth <= 625.) {
   *dep1 = 600; *dep2 = 625; goto cont;
}
if (depth <= 650.) {
   *dep1 = 625; *dep2 = 650; goto cont;
}
if (depth <= 675.) {
   *dep1 = 650; *dep2 = 675; goto cont;
}
if (depth <= 700.) {
   *dep1 = 675; *dep2 = 700; goto cont;
}
if (depth <= 725.) {
   *dep1 = 700; *dep2 = 725; goto cont;
}

cont:

return;

}
