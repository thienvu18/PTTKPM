using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
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
using System.Windows.Threading;

namespace BT04
{
    /// <summary>
    /// Interaction logic for DigitalTimer.xaml
    /// </summary>
    public partial class DongHoDienTu : UserControl
    {
        private DispatcherTimer dispatcherTimer;

        public int Minute
        {
            get { return Int32.Parse(GetValue(MinuteProperty).ToString()); }
            set { SetValue(MinuteProperty, value); }
        }

        public int Second
        {
            get { return Int32.Parse(GetValue(SecondProperty).ToString()); }
            set { SetValue(SecondProperty, value); }
        }

        public string DesiredTime
        {
            get { return GetValue(DesiredTimeProperty).ToString(); }
            set { SetValue(DesiredTimeProperty, value); }
        }

        public delegate void DesiredTimeDelegate();

        public event DesiredTimeDelegate OnDesiredTime;

        public static DependencyProperty MinuteProperty = DependencyProperty.Register(
            "Minute",
            typeof(int),
            typeof(DongHoDienTu),
            new PropertyMetadata(0)
        );

        public static DependencyProperty SecondProperty = DependencyProperty.Register(
            "Second",
            typeof(int),
            typeof(DongHoDienTu),
            new PropertyMetadata(0)
        );

        public static DependencyProperty DesiredTimeProperty = DependencyProperty.Register(
            "DesiredTime",
            typeof(string),
            typeof(DongHoDienTu),
            new PropertyMetadata("60:60")
        );

        public DongHoDienTu()
        {
            InitializeComponent();

            dispatcherTimer = new DispatcherTimer();
            dispatcherTimer.Tick += new EventHandler(onTimer);
            dispatcherTimer.Interval = new TimeSpan(0, 0, 1);
        }

        public void start()
        {
            dispatcherTimer.Start();
        }

        public void stop()
        {
            dispatcherTimer.Stop();
            Minute = 0;
            Second = 0;
            updateUI();
        }

        public void pause()
        {
            dispatcherTimer.Stop();
        }

        public void resume()
        {
            dispatcherTimer.Start();
        }

        private void onTimer(object sender, EventArgs e)
        {
            Second += 1;

            if (Second == 60)
            {
                Second = 0;
                Minute += 1;

                if (Minute == 60)
                {
                    Minute = 0;
                }
            }

            updateUI();

            int desiredMinute = getDesiredMinute();
            int desiredSecond = getDesiredSecond();

            if (Minute == desiredMinute && Second == desiredSecond) { 
                if (OnDesiredTime != null && desiredMinute != -1)
                {
                    OnDesiredTime();
                }
            }
        }

        private int getDesiredMinute()
        {
            Regex rx = new Regex(@"([0-5][0-9]):([0-5][0-9])", RegexOptions.Compiled | RegexOptions.IgnoreCase);
            MatchCollection matches = rx.Matches(DesiredTime);

            if (matches.Count != 1 || matches[0].Groups.Count != 3)
            {
                return -1;
            }

            return Int32.Parse(matches[0].Groups[1].Value);
        }

        private int getDesiredSecond()
        {
            Regex rx = new Regex(@"([0-5][0-9]):([0-5][0-9])", RegexOptions.Compiled | RegexOptions.IgnoreCase);
            MatchCollection matches = rx.Matches(DesiredTime);

            if (matches.Count != 1 || matches[0].Groups.Count != 3)
            {
                return -1;
            }

            return Int32.Parse(matches[0].Groups[2].Value);
        }

        private void updateUI()
        {
            int secondFirstPart = Second / 10;
            int secondSecondPart = Second % 10;
            int minuteFirstPart = Minute / 10;
            int minuteSecondPart = Minute % 10;

            String secondFirstPartSrc = @"Resources/" + secondFirstPart + ".png";
            String secondSecondPartSrc = @"Resources/" + secondSecondPart + ".png";
            String minuteFirstPartSrc = @"Resources/" + minuteFirstPart + ".png";
            String minuteSecondPartSrc = @"Resources/" + minuteSecondPart + ".png";

            igSecondFirstPart.Source = new BitmapImage(new Uri(secondFirstPartSrc, UriKind.Relative));
            igSecondSecondPart.Source = new BitmapImage(new Uri(secondSecondPartSrc, UriKind.Relative));
            igMinuteFirstPart.Source = new BitmapImage(new Uri(minuteFirstPartSrc, UriKind.Relative));
            igMinuteSecondPart.Source = new BitmapImage(new Uri(minuteSecondPartSrc, UriKind.Relative));

        }
    }
}
