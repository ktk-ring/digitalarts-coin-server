import hypermedia.net.*;

import java.util.Arrays;

static ArrayList<String> arr_id = new ArrayList<>();                // 카드 ID

static ArrayList<Integer> arr_balance = new ArrayList<>();          // 남은 칩 (잔액)
static ArrayList<Integer> arr_invested = new ArrayList<>();         // 넣은 칩

static ArrayList<Integer> arr_c_type = new ArrayList<>();           // 구매한 코인 종류
static ArrayList<Integer> arr_c_amount = new ArrayList<>();         // 소유한 코인 수

Integer[] coinNum = {1, 2, 3, 4, 5};                                // 코인 순서
String[] coinName = {"식품", "챗", "테크", "엔터", "건설"};         // 코인 이름
Integer[] coinPrice = {c00, c01, c02, c03, c04};                    // 유동 코인 가격

static String msg = "msg_null";      // 수신 메시지
static String dp = "display_null";   // 처리 메시지

static String log = "";

public class udp_server extends Thread {
  UDP udp;
  int port = 7750;
  String ip = "192.168.0.17";
  udp_server(int _port) {
    port = _port;
    udp = new UDP(this, port);
    udp.listen(true);
  }

  void send(String _data, String _ip, int _port) {
    udp.send( _data, _ip, _port);
  }

  public void run() {
    try {
      while (!Thread.currentThread().isInterrupted()) {

        Thread.sleep(500);
      }
    }
    catch(Exception e) {
      println("thread error..." + e);
    }
  }
  
  void receive( byte[] data, String receive_ip, int receive_port) {

    msg = new String(data);
    String msgS[] = msg.split(",");
    println(msg);
    int id_pos = parseInt(arr_id.indexOf(msgS[1]));
    
    /* 정보 조회 */
    if (msgS.length >= 2 && (msg.contains("##RF")) ) {
      try {
        println("arr index: " + arr_balance.size());
        if (arr_id.contains(msgS[1])) {  // 존재하는 ID라면
          println("id_pos: "+id_pos);

          int coins = arr_c_amount.get(id_pos);
          int val = coinPrice[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))];

          String f1 = "남은 칩: "+arr_balance.get(id_pos)+"칩";
          String f2 = "투자한 금액: "+arr_invested.get(id_pos)+"칩";
          String f3 = "코인 종류: "+arr_c_type.get(id_pos);
          String f4 = "소유한 코인 수: "+coins+"개";
          String f5 = "현재 코인 가치: "+coins*val+"칩";
          dp = "정상 조회되었습니다.\n\n"+f1+"\n"+f2+"\n"+f3+"\n"+f4+"\n"+f5;
          println(dp);

          log = msgS[1]+"님이 ID를 조회했습니다.";
          cnt_msg = 1;

          String send = "##RFOK,"+String.valueOf(arr_invested.get(id_pos))+","+String.valueOf(coins)+","+String.valueOf(arr_c_type.get(id_pos))+","+String.valueOf(coins*val)+",";
          println("udp: "+send);
          udp.send(send, receive_ip, receive_port);
        } else {
          dp = "ID: "+msgS[1]+"\n등록되지 않은 ID입니다.";
          println(dp);
          log = "등록되지 않은 ID입니다.";
          cnt_msg = 1;
          udp.send("##RFERR", receive_ip, receive_port);    // 송신
        }
      }
      catch(Exception e) {
        dp = "##RFERR";
        println("Exception Error: "+e);
      }
    }

    /* 코인 구매 */
    if (msgS.length >= 4 && (msg.contains("##RB")) ) {
      try {
        if (arr_id.contains(msgS[1]) == false) {  // 존재하지 않으면 정보 등록
          dp = "정상 등록되었습니다.\nID: "+msgS[1];
          arr_id.add(msgS[1]);                    // ID 등록
          arr_balance.add(10000);                   // 잔액 100칩
          arr_invested.add(0);                    // 투자금 0칩
          arr_c_type.add(parseInt(msgS[2]));      // 코인 종류 설정
          arr_c_amount.add(0);                    // 코인 수 0개
          println(dp);
        }
        id_pos = parseInt(arr_id.indexOf(msgS[1]));
        if (Arrays.asList(coinNum).contains(parseInt(arr_c_type.get(id_pos)))) {          // 존재하는 코인이며
          if (parseInt(msgS[3]) <= parseInt(arr_balance.get(id_pos))) {                   // 결제한 금액이 잔액 이하라면
          
            int change = parseInt(msgS[3])%coinPrice[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))];  // 거스름돈 계산

            int bought = parseInt(msgS[3])/coinPrice[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))];  // 구매한 코인 수 계산

            arr_balance.set(id_pos, arr_balance.get(id_pos)-parseInt(msgS[3])+change);    // 칩을 차감한다

            arr_invested.set(id_pos, arr_invested.get(id_pos)+parseInt(msgS[3])-change);  // 투자 금액을 누적한다

            if (arr_c_type.get(id_pos) == 6) {
              arr_c_type.set(id_pos, parseInt(msgS[2]));
            }

            arr_c_amount.set(id_pos, arr_c_amount.get(id_pos)+bought); // 코인을 준다

            String b1 = "지불한 금액: "+msgS[3]+"칩";
            String b2 = "거스름돈: "+change+"칩";
            String b3 = "코인 종류: "+coinName[arr_c_type.get(id_pos)-1]+" 코인";
            String b4 = "구매한 코인 수: "+bought+"개";
            String b5 = "가진 코인 수: "+arr_c_amount.get(id_pos)+"개";

            dp = "정상 구매되었습니다.\n\n"+b1+"\n"+b2+"\n"+b3+"\n"+b4+"\n"+b5;
            println("\n"+dp);

            log = msgS[1]+"님이 "+coinName[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))]+" 코인을 "+bought+"개 구매했습니다.";
            cnt_msg = 1;

            String send = "##RBOK,"+String.valueOf(change)+","+String.valueOf(bought)+","+String.valueOf(arr_c_amount.get(id_pos))+",";
            println("udp: "+send);
            udp.send(send, receive_ip, receive_port);    // 송신
          } else {
            dp = "잔여 칩이 부족합니다.";
            println(dp);
            log = dp;
            cnt_msg = 1;
          }
        } else {
          dp = "존재하지 않는 코인입니다.";
          println(dp);
          log = dp;
          cnt_msg = 1;
        }
      }
      catch(Exception e) {
        dp = "##RBERR";
        println("Exception Error: "+e);
      }
    }

    /* 코인 판매 */
    if (msgS.length >= 3 && (msg.contains("##RS")) ) {
      try {
        if (arr_id.contains(msgS[1])) {  // 존재하는 ID이고
          if (parseInt(msgS[2]) <= parseInt(arr_c_amount.get(id_pos))) {  // 판매할 코인이 소유량 이하라면
            int sold = coinPrice[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))]*parseInt(msgS[2]);  // 판매하고 받는 칩
            
            arr_c_amount.set(id_pos, arr_c_amount.get(id_pos)-parseInt(msgS[2]));  // 코인 개수를 차감한다
            
            arr_balance.set(id_pos, arr_balance.get(id_pos)+sold);  // 칩을 준다
            
            String s1 = "판매한 코인 수: "+msgS[2]+"개";
            String s2 = "코인 종류: "+coinName[arr_c_type.get(id_pos)-1]+" 코인";
            String s3 = "받은 금액: "+sold+"칩";
            String s4 = "가진 코인 수: "+arr_c_amount.get(id_pos)+"개";
            
            dp = "정상 판매되었습니다.\n\n"+s1+"\n"+s2+"\n"+s3+"\n"+s4;
            println("\n"+dp);
            
            log = msgS[1]+"님이 "+coinName[Arrays.asList(coinNum).indexOf(arr_c_type.get(id_pos))]+" 코인을 "+msgS[2]+"개 판매했습니다.";
            cnt_msg = 1;

            String send = "##RSOK,"+String.valueOf(arr_c_amount.get(id_pos))+","+String.valueOf(sold)+",";
            println("udp: "+send);
            udp.send(send, receive_ip, receive_port);         // 송신
          } else {
            dp = "판매할 코인이 부족합니다.";
            println(dp);
            udp.send("##RSERR", receive_ip, receive_port);    // 송신
          }
        } else {
          dp = "존재하지 않는 ID입니다.";
          println(dp);
          udp.send("##RSERR", receive_ip, receive_port);      // 송신
        }
      }
      catch(Exception e) {
        dp = "##RSERR";
        println("Exception Error: "+e);
      }
    }

    /* 정보 삭제 */
    if (msgS.length >= 2 && (msg.contains("##RD")) ) {
      try {
        if (arr_id.contains(msgS[1])) {
          dp = "정상 삭제되었습니다.\nID: "+msgS[1];
          arr_id.remove(id_pos);        // ID 삭제
          arr_balance.remove(id_pos);
          arr_invested.remove(id_pos);
          arr_c_type.remove(id_pos);
          arr_c_amount.remove(id_pos);

          log = msgS[1]+"님이 ID를 삭제했습니다.";
          cnt_msg = 1;

          String send = "##RDOK";
          println("udp: "+send);
          udp.send(send, receive_ip, receive_port);         // 송신
        } else {
          dp = msgS[1]+"은(는) 이미 삭제되었거나 존재하지 않는 ID입니다.";
          log = "이미 삭제되었거나 존재하지 않는 ID입니다.";
          udp.send("##RDERR", receive_ip, receive_port);    // 송신
        }
      }
      catch(Exception e) {
        dp = "##RDERR";
        println("Exception Error: "+e);
      }
    }
    save_backup();
  }
}
