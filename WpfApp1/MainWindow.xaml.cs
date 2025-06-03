using System.Linq;
using System.Windows;
using WpfApp1.Data;
using WpfApp1.Data.Models;

namespace WpfApp1
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

        private void Button_OpenApp(object sender, RoutedEventArgs e)
        {
            string login = LoginTextBox.Text.Trim();
            string password = PasswordBox.Password;

            using var db = new ApplicationDbContext();
            var user = db.UsersDbs.FirstOrDefault(u => u.LoginName == login && u.PasswordName == password);

            if (user != null)
            {
                var wWindow = new Window1(user);
                wWindow.Show();
            }
            else { ErrorTextBlock.Text = "Неверные данные для входа"; }
        }

        private void Button_CloseApp(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}