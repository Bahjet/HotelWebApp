package model;

import java.util.Date;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import web.AppListener;

public class CustomerStay {
    public static final double HOUR_PRICE = 30.0;

    private long rowId;
    private String CustomerName;// (nome do cliente)
    private String RoomNumber;//  (numero quarto)
    private String VehiclePlate;// VehiclePlate 
    private Date beginStay;//     entrada
    private Date endStay;//       saida
    private double price;//       preço

    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS customers_stays(\n"    //tabela banco de dados
                + "    customer_name varchar(50) not null\n"     //cliente_nome
                + "    , room_number int(1000) not null\n"       //apartamento_numero  
                + "    , vehicle_plate varchar(7) not null\n"    //placa do veiculo em que o ussuario chegou em nosso estabelecimento
                + "    , begin_stay datetime not null\n"        
                + "    , end_stay datetime\n"
                + "    , price numeric(10,2)\n"
                + ")";
    }
    
    public static ArrayList<CustomerStay> getList() throws Exception {
        ArrayList<CustomerStay> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT rowid, * FROM customers_stays"
                + " WHERE end_stay IS NULL");
        while (rs.next()) {
            CustomerStay vs = new CustomerStay(
                    rs.getLong("rowid"),
                     rs.getString("customer_name"),
                     rs.getString("room_number"),
                     rs.getString("vehicle_plate"),
                     rs.getTimestamp("begin_stay")
            );
            list.add(vs);
        }
        rs.close();
        s.close();
        con.close();
        return list;
    }
    
    public static ArrayList<CustomerStay> getHistoryList() throws Exception {
        ArrayList<CustomerStay> list = new ArrayList<>();
        String SQL = "SELECT rowid, * FROM customers_stays WHERE end_stay IS NOT NULL ";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        ResultSet rs = s.executeQuery();
        while (rs.next()) {
            CustomerStay vs = new CustomerStay(
                    rs.getLong("rowid"),
                     rs.getString("customer_name"),
                     rs.getString("room_number"),
                     rs.getString("vehicle_plate"),
                     rs.getTimestamp("begin_stay"),
                     rs.getTimestamp("end_stay"),
                     rs.getDouble("price")
            );
            list.add(vs);
        }
        rs.close();
        s.close();
        con.close();
        return list;
    }
    
    public static void addCustomerStay(String name, String room, String plate)
        throws Exception {
    String SQL = "INSERT INTO customers_stays VALUES("
            + "?" //customer_name
            + ", ?" //room_number
            + ", ?" //vehicle_plate
            + ", ?" //begin_stay
            + ", NULL" //end_stay
            + ", NULL" //price
            + ")";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setString(1, name);
        s.setString(2, room);
        s.setString(3, plate);
        s.setTimestamp(4, new Timestamp(new Date().getTime()));
        s.execute();
        s.close();
        con.close();
    }

    public static void finishCustomerStay(long rowid, double price)
            throws Exception {
        String SQL = "UPDATE customers_stays"
                + " SET end_stay=?, price=?"
                + " WHERE rowid =?";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setTimestamp(1, new Timestamp(new Date().getTime()));
        s.setDouble(2, price);
        s.setLong(3, rowid);
        s.execute();
        s.close();
        con.close();
    }
    public static CustomerStay getStay(long rowid) throws Exception {
        CustomerStay cs = null;
        String SQL = "SELECT rowid, * FROM customers_stays WHERE rowid=?";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setLong(1, rowid);
        ResultSet rs = s.executeQuery();
        if (rs.next()) {
            cs = new CustomerStay(
                    rs.getInt("rowid"),
                     rs.getString("customer_name"),
                     rs.getString("room_number"),
                     rs.getString("vehicle_plate"),
                     rs.getTimestamp("begin_stay")
            );
        }
        rs.close();
        s.close();
        con.close();
        return cs;
    }
    
    public CustomerStay(long rowId, String CustomerName, String RoomNumber, String VehiclePlate, Date beginStay) {
        this.rowId = rowId;
        this.CustomerName = CustomerName;
        this.RoomNumber = RoomNumber;
        this.VehiclePlate = VehiclePlate;
        this.beginStay = beginStay;
    }
    
    public CustomerStay(long rowId, String CustomerName, String RoomNumber, String VehiclePlate, Date beginStay, Date endStay, double price) {
        this.rowId = rowId;
        this.CustomerName = CustomerName;
        this.RoomNumber = RoomNumber;
        this.VehiclePlate = VehiclePlate;
        this.beginStay = beginStay;
        this.endStay = endStay;
        this.price = price;
    }
    
    

    public long getRowId() {
        return rowId;
    }

    public void setRowId(long rowId) {
        this.rowId = rowId;
    }

    public String getCustomerName() {
        return CustomerName;
    }

    public void setCustomerName(String CustomerName) {
        this.CustomerName = CustomerName;
    }

    public String getRoomNumber() {
        return RoomNumber;
    }

    public void setRoomNumber(String RoomNumber) {
        this.RoomNumber = RoomNumber;
    }

    public String getVehiclePlate() {
        return VehiclePlate;
    }

    public void setVehiclePlate(String VehiclePlate) {
        this.VehiclePlate = VehiclePlate;
    }

    public Date getBeginStay() {
        return beginStay;
    }

    public void setBeginStay(Date beginStay) {
        this.beginStay = beginStay;
    }

    public Date getEndStay() {
        return endStay;
    }

    public void setEndStay(Date endStay) {
        this.endStay = endStay;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    
}
