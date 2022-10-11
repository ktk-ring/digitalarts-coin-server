int port = 7750;

udp_server udp_server = new udp_server(port);
Table price;

long before_millis = 0;

/* 코인 가격 초기화 */
static Integer c00 = 1;
static Integer c01 = 1;
static Integer c02 = 1;
static Integer c03 = 1;
static Integer c04 = 1;

static String date = str(year())+"."+str(month())+"."+str(day())+"_"+str(hour())+";"+str(minute())+";"+str(second());

PFont fontBd;
PFont fontMd;

void setup() {
  
  // price = loadTable("coin_value_0929.csv", "header");      // 1일차 엑셀 불러오기
  price = loadTable("coin_value_0930.csv", "header");       // 2일차 엑셀 불러오기
  load_backup();      // 백업 불러오기
  
  udp_server.start();
  println("Server start...");
  
  fontBd = createFont("GmarketSansBold.otf", 36);
  fontMd = createFont("GmarketSansMedium.otf", 24);
  
  fullScreen();
  //size(1280, 720);
  background(#96C8FF);
  
  textAlign(CENTER, CENTER);
  textFont(fontBd);
  textSize(height/3);
  fill(#B2D8FF);
  text("디 아\n코 인", width/2, height/2);
  
  fill(30);
  strokeWeight(3);
  
  int cx_1 = width-80;
  int cy_1 = height-160;
  
  fill(30);
  
  fill(#CBE5FF);
  rect(width-10, 10, -690, 120);
  rect(width-10, 140, -690, height-370);
  
  textAlign(CENTER);
  fill(30);
  textSize(60);
  text("디아코인 서버", width-350, 90);
  
  fill(#FFCC98);
  rect(width-10, height-120, -690, -100);
  
  textAlign(CENTER);
  fill(30);
  textSize(36);
  text("코인", width-625, cy_1);
  
  text("식품", cx_1-400, cy_1);
  text("챗",   cx_1-300, cy_1);
  text("테크", cx_1-200, cy_1);
  text("엔터", cx_1-100, cy_1);
  text("건설", cx_1,     cy_1);
  
}



void draw() {
  
  update();
  
}



int cnt_val = 0;
static int cnt_msg = 0;
int log_y = 0;

void update() {

  if (before_millis + 300000/*밀리초*/ <= millis()) {    // 가격 변동 타이밍 조정
    cnt_val++;
    if (cnt_val > price.getRowCount()) {
      cnt_val = 1;
    }
    
    int cx_2 = width-80;
    int cy_2 = height-50;

    fill(#FFCC98);
    rect(width-10, height-10, -690, -100);
    
    textAlign(CENTER);
    textFont(fontBd);
    fill(30);
    text(cnt_val+"회", width-625, cy_2);
    
    text(price.getInt(cnt_val-1, "coin00"), cx_2-400, cy_2);
    text(price.getInt(cnt_val-1, "coin01"), cx_2-300, cy_2);
    text(price.getInt(cnt_val-1, "coin02"), cx_2-200, cy_2);
    text(price.getInt(cnt_val-1, "coin03"), cx_2-100, cy_2);
    text(price.getInt(cnt_val-1, "coin04"), cx_2,     cy_2);
    
    /* 코인 저장 */
    c00 = price.getInt(cnt_val-1, "coin00");
    c01 = price.getInt(cnt_val-1, "coin01");
    c02 = price.getInt(cnt_val-1, "coin02");
    c03 = price.getInt(cnt_val-1, "coin03");
    c04 = price.getInt(cnt_val-1, "coin04");
    coinPrice[0] = c00;
    coinPrice[1] = c01;
    coinPrice[2] = c02;
    coinPrice[3] = c03;
    coinPrice[4] = c04;
    
    String msg_client = "##UI,"+(cnt_val-1)+","+c00+","+c01+","+c02+","+c03+","+c04+",";
    udp_server.send(msg_client,"192.168.0.18", port);
    println(msg_client);

    before_millis = millis();
  }

  if (cnt_msg == 1) {
    cnt_msg = 0;
    if (log_y > height-130) {
      log_y = 0;
    }
    textAlign(LEFT);
    fill(#CBE5FF);
    rect(10, 10+log_y, width-720, 120);
    fill(30);
    textFont(fontMd);
    
    date = str(year())+"."+str(month())+"."+str(day())+"_"+str(hour())+";"+str(minute())+";"+str(second());
    println(date);
    text("["+date+"]\n"+msg+"\n"+log, 30, 45+log_y);
    fill(#CBE5FF);
    rect(width-10, 140, -690, height-370);
    fill(30);
    textSize(36);
    text(dp, width-680, 200);
    log_y = log_y + 130;
  }  
}
