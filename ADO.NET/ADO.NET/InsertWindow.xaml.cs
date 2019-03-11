using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
using System.Windows.Shapes;
using System.Configuration;
using System.Data;

namespace ADO.NET
{
    /// <summary>
    /// Interaction logic for InsertWindow.xaml
    /// </summary>
    public partial class InsertWindow : Window
    {
        public InsertWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }



        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            int idThanhVienCu = int.Parse(tbThanhVienCuId.Text.Substring(1));

            if (idThanhVienCu != 0)
            {
                if (((ComboBoxItem)cbLoaiQuanHe.SelectedItem).Name == "__0")
                {
                    MessageBox.Show("Chưa chọn loại quan hệ");
                    return;
                }

                if (dpNgayPhatSinh.SelectedDate == null)
                {
                    MessageBox.Show("Chưa chọn ngày phát sinh quan hệ");
                    return;
                }
            }

            if (tbHoVaTen.Text == "")
            {
                MessageBox.Show("Chưa nhập họ tên");
                return;
            }

            if (dpNgayGioSinh.SelectedDate == null)
            {
                MessageBox.Show("Chưa chọn ngày sinh");
                return;
            }

            string loaiQuanHe = ((ComboBoxItem)cbLoaiQuanHe.SelectedItem).Content.ToString();
            DateTime ngayPhatSinh = dpNgayPhatSinh.SelectedDate == null? DateTime.Today: (DateTime)dpNgayPhatSinh.SelectedDate;
            string hoTen = tbHoVaTen.Text;
            string gioiTinh = ((ComboBoxItem)cbGioiTinh.SelectedItem).Content.ToString();
            DateTime ngayGioSinh = (DateTime)dpNgayGioSinh.SelectedDate;
            string queQuan = tbQueQuan.Text;
            string ngheNghiep = tbNgheNghiep.Text;
            string diaChi = tbDiaChi.Text;

            if (ngayPhatSinh > DateTime.Today)
            {
                MessageBox.Show("Ngày phát sinh không thể lớn hơn ngày hiện tại");
                return;
            }

            if (ngayGioSinh > DateTime.Today)
            {
                MessageBox.Show("Ngày giờ sinh không thể lớn hơn ngày hiện tại");
                return;
            }

            string path = ConfigurationManager.ConnectionStrings["ADO.NET.Properties.Settings.CGPConnectionString"].ConnectionString;

            SqlConnection connection = new SqlConnection(path);
            connection.Open();

            SqlCommand cmd = new SqlCommand("proc_addMember", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.Add(new SqlParameter("@idThanhVienCu", idThanhVienCu == 0? -1 : idThanhVienCu));
            cmd.Parameters.Add(new SqlParameter("@loaiQuanHe", idThanhVienCu == 0 ? "" : loaiQuanHe));
            cmd.Parameters.Add(new SqlParameter("@ngayPhatSinh", idThanhVienCu == 0 ? null : ngayPhatSinh.ToString("yyyy-MM-dd")));
            cmd.Parameters.Add(new SqlParameter("@hoTen", hoTen));
            cmd.Parameters.Add(new SqlParameter("@gioiTinh", gioiTinh));
            cmd.Parameters.Add(new SqlParameter("@ngayGioSinh", ngayGioSinh.ToString("yyyy-MM-dd")));
            cmd.Parameters.Add(new SqlParameter("@queQuan", queQuan));
            cmd.Parameters.Add(new SqlParameter("@ngheNghiep", ngheNghiep));
            cmd.Parameters.Add(new SqlParameter("@diaChi", diaChi));

            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Thêm thành viên thành công");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                MessageBox.Show("Không thể thêm thành viên");
            }

            connection.Close();

        }

        private void tbThanhVienCu_KeyUp(object sender, KeyEventArgs e)
        {
            bool found = false;
            var border = (resultStack.Parent as ScrollViewer).Parent as Border;

            string query = (sender as TextBox).Text;

            if (query.Length == 0)
            {
                // Clear   
                resultStack.Children.Clear();
                border.Visibility = Visibility.Collapsed;
            }
            else
            {
                border.Visibility = Visibility.Visible;
                try
                {
                    resultStack.Children.Clear();

                    string path = ConfigurationManager.ConnectionStrings["ADO.NET.Properties.Settings.CGPConnectionString"].ConnectionString;
                    SqlConnection connection = new SqlConnection(path);
                    connection.Open();

                    string sql = "SELECT id, hoTen FROM ThanhVien WHERE hoTen LIKE N'" + tbThanhVienCu.Text + "%'";
                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                int id = reader.GetInt32(0);
                                string text = reader.GetString(1);

                                // The word starts with this... Autocomplete must work   
                                TextBlock block = new TextBlock();

                                // Add the text   
                                block.Text = text;
                                //Add id
                                block.Name = "_" + id;

                                // A little style...   
                                block.Margin = new Thickness(2, 3, 2, 3);
                                block.Cursor = Cursors.Hand;

                                // Mouse events   
                                block.MouseLeftButtonUp += (s, notCare) =>
                                {
                                    tbThanhVienCu.Text = text;
                                    tbThanhVienCuId.Text = block.Name;
                                    border.Visibility = Visibility.Collapsed;
                                };

                                block.MouseEnter += (s, notCare) =>
                                {
                                    TextBlock b = s as TextBlock;
                                    b.Background = Brushes.PeachPuff;
                                };

                                block.MouseLeave += (s, notCare) =>
                                {
                                    TextBlock b = s as TextBlock;
                                    b.Background = Brushes.Transparent;
                                };

                                // Add to the panel   
                                resultStack.Children.Add(block);
                                found = true;
                            }
                        }
                    }

                    if (!found)
                    {
                        resultStack.Children.Add(new TextBlock() { Text = "Không tìm thấy thành viẻn" });
                    }


                    connection.Close();
                }
                catch
                {
                }
            }


        }
    }
}
