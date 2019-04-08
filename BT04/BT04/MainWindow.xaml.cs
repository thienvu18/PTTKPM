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

namespace BT04
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void DongHoDienTu_OnDesiredTime()
        {
            MessageBox.Show("Đã đến giờ hẹn trước, bấm OK để kết thúc chương trình");
            System.Windows.Application.Current.Shutdown();
        }

        private void BtnStart_Click(object sender, RoutedEventArgs e)
        {
            digitalTimer.start();
        }

        private void BtnStop_Click(object sender, RoutedEventArgs e)
        {
            digitalTimer.stop();
        }

        private void BtnPause_Click(object sender, RoutedEventArgs e)
        {
            digitalTimer.pause();
        }

        private void BtnResume_Click(object sender, RoutedEventArgs e)
        {
            digitalTimer.resume();
        }
    }
}
