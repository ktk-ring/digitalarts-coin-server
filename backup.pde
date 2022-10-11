void save_backup() {      // 백업 내보내기
  
  ArrayList<String> arr_str_balance = new ArrayList<>(arr_balance.size());
  
  for (Integer myInt : arr_balance) {
    arr_str_balance.add(String.valueOf(myInt));
  }
  
  ArrayList<String> arr_str_invested = new ArrayList<>(arr_invested.size());
  
  for (Integer myInt : arr_invested) {
    arr_str_invested.add(String.valueOf(myInt));
  }
  
  ArrayList<String> arr_str_c_type = new ArrayList<>(arr_c_type.size());
  
  for (Integer myInt : arr_c_type) {
    arr_str_c_type.add(String.valueOf(myInt));
  }
  
  ArrayList<String> arr_str_c_amount = new ArrayList<>(arr_c_amount.size());
  
  for (Integer myInt : arr_c_amount) {
    arr_str_c_amount.add(String.valueOf(myInt));
  }
  
  String[] id_backup_save = arr_id.toArray(new String[arr_id.size()]);                            // 카드 ID
  String[] balance_backup_save = arr_str_balance.toArray(new String[arr_balance.size()]);         // 남은 칩
  String[] invested_backup_save = arr_str_invested.toArray(new String[arr_invested.size()]);      // 넣은 칩
  String[] c_type_backup_save = arr_str_c_type.toArray(new String[arr_c_type.size()]);            // 구매한 코인 종류
  String[] c_amount_backup_save = arr_str_c_amount.toArray(new String[arr_c_amount.size()]);      // 소유한 코인 수
  
  date = str(year())+"."+str(month())+"."+str(day())+"_"+str(hour())+";"+str(minute())+";"+str(second());
  
  saveStrings("/backup/id.txt", id_backup_save);              // 카드 ID
  saveStrings("/backup/balance.txt", balance_backup_save);    // 남은 칩 (잔액)
  saveStrings("/backup/invested.txt", invested_backup_save);  // 넣은 칩
  saveStrings("/backup/c_type.txt", c_type_backup_save);      // 구매한 코인 종류
  saveStrings("/backup/c_amount.txt", c_amount_backup_save);  // 소유한 코인 수
}



void load_backup() {      // 백업 불러오기
  
  String[] id_backup_load = loadStrings("/backup/id.txt");              // 카드 ID
  String[] balance_backup_load = loadStrings("/backup/balance.txt");    // 남은 칩
  String[] invested_backup_load = loadStrings("/backup/invested.txt");  // 넣은 칩
  String[] c_type_backup_load = loadStrings("/backup/c_type.txt");      // 구매한 코인 종류
  String[] c_amount_backup_load = loadStrings("/backup/c_amount.txt");  // 소유한 코인 수
  
  for (int i = 0 ; i < id_backup_load.length; i++) {
    arr_id.add(id_backup_load[i]);
  }
  
  for (int i = 0 ; i < balance_backup_load.length; i++) {
    int[] num_balance_backup = Arrays.stream(balance_backup_load).mapToInt(Integer::parseInt).toArray();
    println(num_balance_backup[i]);
    arr_balance.add(num_balance_backup[i]);
  }
  
  for (int i = 0 ; i < balance_backup_load.length; i++) {
    int[] num_invested_backup = Arrays.stream(invested_backup_load).mapToInt(Integer::parseInt).toArray();
    println(num_invested_backup[i]);
    arr_invested.add(num_invested_backup[i]);
  }
  
  for (int i = 0 ; i < balance_backup_load.length; i++) {
    int[] num_c_type_backup = Arrays.stream(c_type_backup_load).mapToInt(Integer::parseInt).toArray();
    println(num_c_type_backup[i]);
    arr_c_type.add(num_c_type_backup[i]);
  }
  
  for (int i = 0 ; i < balance_backup_load.length; i++) {
    int[] num_c_amount_backup = Arrays.stream(c_amount_backup_load).mapToInt(Integer::parseInt).toArray();
    println(num_c_amount_backup[i]);
    arr_c_amount.add(num_c_amount_backup[i]);
  }
  
}
