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
using System.Windows.Shapes;
using WpfApp1.Data.Models;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для Window1.xaml
    /// </summary>
    public partial class Window1 : Window
    {
        private UsersDb _user;

        public Window1(UsersDb user)
        {
            InitializeComponent();

            _user = user;

            if (_user.LoginName == "1")
            {
                MessageBox.Show("Доступ отклонен!");
                this.Close();
            }
            else { WelcomeTextBlock.Text = $"Добро пожаловать, {_user.LoginName}!"; }

        }

        private void FilterButton_Click(object sender, RoutedEventArgs e)
        {

        }

        private void AddRequest_Click(object sender, RoutedEventArgs e)
        {

        }

        private void EditRequest_Click(object sender, RoutedEventArgs e)
        {

        }

        private void DeleteRequest_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
