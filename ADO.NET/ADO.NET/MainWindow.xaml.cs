using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Collections;

namespace ADO.NET
{
    public class ThanhVien
    {
        public int id { get; set; }
        public string hoTen { get; set; }
        public string gioiTinh { get; set; }
        public string ngayGioSinh { get; set; }
        public string queQuan { get; set; }
        public string ngheNghiep { get; set; }
        public string diaChi { get; set; }
    }
    
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void loadData()
        {
            ArrayList al = new ArrayList();
            string path = ConfigurationManager.ConnectionStrings["ADO.NET.Properties.Settings.CGPConnectionString"].ConnectionString;

            SqlConnection connection = new SqlConnection(path);
            connection.Open();

            string sql = "SELECT * FROM func_getHoSo()";
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    int id;
                    string hoTen;
                    string gioiTinh;
                    string ngayGioSinh;
                    string queQuan;
                    string ngheNghiep;
                    string diaChi;

                    while (reader.Read())
                    {
                        id = reader.IsDBNull(0) ? -1 : reader.GetInt32(0);
                        hoTen = reader.IsDBNull(1) ? "" : reader.GetString(1);
                        gioiTinh = reader.IsDBNull(2) ? "" : reader.GetString(2);
                        ngayGioSinh = reader.IsDBNull(3) ? "" : reader.GetString(3);
                        queQuan = reader.IsDBNull(4) ? "" : reader.GetString(4);
                        ngheNghiep = reader.IsDBNull(3) ? "" : reader.GetString(5);
                        diaChi = reader.IsDBNull(4) ? "" : reader.GetString(6);

                        al.Add(new ThanhVien() { id = id, hoTen = hoTen, gioiTinh = gioiTinh, ngayGioSinh = ngayGioSinh, queQuan = queQuan, ngheNghiep = ngheNghiep, diaChi = diaChi });
                    }
                }
            }

            dgView.ItemsSource = al;

            connection.Close();
        }

        private void DataGrid_Loaded(object sender, RoutedEventArgs e)
        {
            loadData();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            InsertWindow insertWindow = new InsertWindow();
            insertWindow.ShowDialog();

            loadData();
        }
    }
}
