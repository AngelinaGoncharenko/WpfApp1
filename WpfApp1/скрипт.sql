-- Используем или создаем базу
--CREATE DATABASE WpfAppWindows;
USE WpfAppWindows

-- Таблица для окна OrdersWindow
CREATE TABLE OrdersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- Вставка интерфейса и логики OrdersWindow
INSERT INTO OrdersWindow (Interface, Logic)
VALUES 
(
N'<Window x:Class="WpfApp2.Windows.OrdersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Заявки" Height="500" Width="400">
    <Grid Margin="10">
        <StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="Партнёр: " Width="120"/>
                <ComboBox x:Name="PartnerComboBox" Width="250" DisplayMemberPath="Name" SelectedValuePath="PartnerID"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="Менеджер: " Width="120"/>
                <ComboBox x:Name="ManagerComboBox" Width="250" DisplayMemberPath="FullName" SelectedValuePath="ManagerID"/>
            </StackPanel>
            <StackPanel Orientation="Vertical" Margin="0,10,0,5">
                <TextBlock Text="Продукты:"/>
                <TextBox x:Name="ProductListTextBox" Height="60" AcceptsReturn="True"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="Дата заявки: " Width="120"/>
                <DatePicker x:Name="OrderDatePicker"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="Статус: " Width="120"/>
                <TextBox x:Name="StatusTextBox" Width="200"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" Margin="0,15,0,0">
                <Button Content="Добавить" Width="80" Margin="5"/>
                <Button Content="Сохранить" Width="80" Margin="5"/>
                <Button Content="Удалить" Width="80" Margin="5"/>
            </StackPanel>
        </StackPanel>
    </Grid>
</Window>',
N'using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using WpfApp2.Data;
using WpfApp2.Data.Models;

namespace WpfApp2.Windows {
    public partial class OrdersWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public OrdersWindow()
        {
            InitializeComponent();
            LoadData();
        }

        private void LoadData()
        {
            PartnerComboBox.ItemsSource = _context.Partners.ToList();
            ManagerComboBox.ItemsSource = _context.Employees.Where(e => e.Position == "Менеджер").ToList();
            OrderDatePicker.SelectedDate = DateTime.Now;
        }

        private void Button_Add_Click(object sender, RoutedEventArgs e)
        {
            ProductListTextBox.Text = "";
            StatusTextBox.Text = "Ожидает подтверждения";
        }

        private void Button_Save_Click(object sender, RoutedEventArgs e)
        {
            if (PartnerComboBox.SelectedItem is Partner partner &&
                ManagerComboBox.SelectedItem is Employee manager)
            {
                var order = new Order
                {
                    PartnerID = partner.PartnerID,
                    ManagerID = manager.EmployeeID,
                    OrderDate = OrderDatePicker.SelectedDate ?? DateTime.Now,
                    Status = StatusTextBox.Text,
                    ProductList = ProductListTextBox.Text
                };

                _context.Orders.Add(order);
                _context.SaveChanges();

                MessageBox.Show("Заявка сохранена");
            }
            else
            {
                MessageBox.Show("Выберите партнера и менеджера");
            }
        }

        private void Button_Delete_Click(object sender, RoutedEventArgs e)
        {
            var selectedPartner = PartnerComboBox.SelectedItem as Partner;
            var selectedOrder = _context.Orders.FirstOrDefault(o => o.PartnerID == selectedPartner.PartnerID);

            if (selectedOrder != null)
            {
                _context.Orders.Remove(selectedOrder);
                _context.SaveChanges();
                MessageBox.Show("Заявка удалена");
            }
        }
    }
}'
);

-- Таблица для окна ManagersWindow
CREATE TABLE ManagersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- Вставка данных в ManagersWindow
INSERT INTO ManagersWindow (Interface, Logic)
VALUES
(
N'<Window x:Class="WpfApp2.Windows.ManagersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Менеджеры" Height="400" Width="600">
    <Grid Margin="10">
        <DataGrid x:Name="ManagersGrid" AutoGenerateColumns="False" IsReadOnly="True" Margin="0,0,0,40">
            <DataGrid.Columns>
                <DataGridTextColumn Header="ФИО" Binding="{Binding FullName}" Width="*"/>
                <DataGridTextColumn Header="Email" Binding="{Binding Email}" Width="*"/>
                <DataGridTextColumn Header="Рейтинг" Binding="{Binding Rating}" Width="*"/>
            </DataGrid.Columns>
        </DataGrid>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
            <Button Content="Обновить" Margin="5" Click="Refresh_Click"/>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Linq;
using System.Windows;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class ManagersWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public ManagersWindow()
        {
            InitializeComponent();
            LoadManagers();
        }

        private void LoadManagers()
        {
            ManagersGrid.ItemsSource = _context.Employees
                .Where(e => e.Position == "Менеджер")
                .ToList();
        }

        private void Refresh_Click(object sender, RoutedEventArgs e)
        {
            LoadManagers();
        }
    }
}'
);

-- Таблица для окна PartnersWindow
CREATE TABLE PartnersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- Вставка данных в PartnersWindow
INSERT INTO PartnersWindow (Interface, Logic)
VALUES
(
N'<Window x:Class="WpfApp2.Windows.PartnersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Партнеры" Height="600" Width="800">
    <Grid Margin="10">
        <DataGrid x:Name="PartnersGrid" AutoGenerateColumns="False" IsReadOnly="True" Margin="0,0,0,50">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Тип" Binding="{Binding PartnerType}" Width="*"/>
                <DataGridTextColumn Header="Компания" Binding="{Binding CompanyName}" Width="*"/>
                <DataGridTextColumn Header="ИНН" Binding="{Binding INN}" Width="*"/>
                <DataGridTextColumn Header="Email" Binding="{Binding Email}" Width="*"/>
                <DataGridTextColumn Header="Рейтинг" Binding="{Binding Rating}" Width="*"/>
            </DataGrid.Columns>
        </DataGrid>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
            <Button Content="Добавить" Margin="5" Click="Add_Click"/>
            <Button Content="Редактировать" Margin="5" Click="Edit_Click"/>
            <Button Content="Удалить" Margin="5" Click="Delete_Click"/>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Linq;
using System.Windows;
using WpfApp2.Data;
using WpfApp2.Data.Models;

namespace WpfApp2.Windows{
    public partial class PartnersWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public PartnersWindow()
        {
            InitializeComponent();
            LoadPartners();
        }

        private void LoadPartners()
        {
            PartnersGrid.ItemsSource = _context.Partners.ToList();
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            var window = new PartnerEditWindow();
            window.ShowDialog();
            LoadPartners();
        }

        private void Edit_Click(object sender, RoutedEventArgs e)
        {
            if (PartnersGrid.SelectedItem is Partner partner)
            {
                var window = new PartnerEditWindow(partner);
                window.ShowDialog();
                LoadPartners();
            }
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            if (PartnersGrid.SelectedItem is Partner partner)
            {
                _context.Partners.Remove(partner);
                _context.SaveChanges();
                LoadPartners();
            }
        }
    }
}'
);


-- ПАРТНЕРЫ
CREATE TABLE PartnerEditWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO PartnerEditWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.PartnerEditWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Редактирование партнера" Height="400" Width="400">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="Тип партнера"/>
            <TextBox x:Name="TypeTextBox"/>
            <TextBlock Text="Название компании"/>
            <TextBox x:Name="CompanyNameTextBox"/>
            <TextBlock Text="ИНН"/>
            <TextBox x:Name="INNTextBox"/>
            <TextBlock Text="Email"/>
            <TextBox x:Name="EmailTextBox"/>
            <TextBlock Text="Рейтинг"/>
            <TextBox x:Name="RatingTextBox"/>
            <Button Content="Сохранить" Click="Save_Click" Margin="0,10,0,0"/>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Windows;
using WpfApp2.Data;
using WpfApp2.Data.Models;

namespace WpfApp2.Windows {
    public partial class PartnerEditWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();
        private Partner _partner;

        public PartnerEditWindow(Partner partner = null)
        {
            InitializeComponent();
            _partner = partner;
            if (_partner != null)
            {
                TypeTextBox.Text = _partner.PartnerType;
                CompanyNameTextBox.Text = _partner.CompanyName;
                INNTextBox.Text = _partner.INN;
                EmailTextBox.Text = _partner.Email;
                RatingTextBox.Text = _partner.Rating.ToString();
            }
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            if (_partner == null)
            {
                _partner = new Partner();
                _context.Partners.Add(_partner);
            }

            _partner.PartnerType = TypeTextBox.Text;
            _partner.CompanyName = CompanyNameTextBox.Text;
            _partner.INN = INNTextBox.Text;
            _partner.Email = EmailTextBox.Text;
            _partner.Rating = int.Parse(RatingTextBox.Text);

            _context.SaveChanges();
            Close();
        }
    }
}'
);

-- СОТРУДНИКИ
CREATE TABLE EmployeeWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO EmployeeWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.EmployeeWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Сотрудники" Height="400" Width="600">
    <Grid>
        <StackPanel Margin="10">
            <Button Content="Добавить сотрудника" Click="AddEmployee_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="EmployeesGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="ФИО" Binding="{Binding FullName}" />
                    <DataGridTextColumn Header="Дата рождения" Binding="{Binding BirthDate}" />
                    <DataGridTextColumn Header="Паспорт" Binding="{Binding Passport}" />
                    <DataGridTextColumn Header="Семья" Binding="{Binding FamilyStatus}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Collections.Generic;
using System.Linq;
using System.Windows;
using WpfApp2.Data;
using WpfApp2.Data.Models;

namespace WpfApp2.Windows {
    public partial class EmployeeWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public EmployeeWindow()
        {
            InitializeComponent();
            LoadEmployees();
        }

        private void LoadEmployees()
        {
            EmployeesGrid.ItemsSource = _context.Employees.ToList();
        }

        private void AddEmployee_Click(object sender, RoutedEventArgs e)
        {
            var empEdit = new EmployeeEditWindow();
            empEdit.ShowDialog();
            LoadEmployees();
        }
    }
}'
);

-- ОКНО: MaterialsWindow
CREATE TABLE MaterialsWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO MaterialsWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.MaterialsWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Материалы" Height="400" Width="700">
    <Grid Margin="10">
        <StackPanel>
            <Button Content="Добавить материал" Click="AddMaterial_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="MaterialsGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Тип" Binding="{Binding MaterialType}" />
                    <DataGridTextColumn Header="Потери (%)" Binding="{Binding LossPercentage}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Windows;
using System.Linq;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class MaterialsWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public MaterialsWindow()
        {
            InitializeComponent();
            LoadMaterials();
        }

        private void LoadMaterials()
        {
            MaterialsGrid.ItemsSource = _context.Materials.ToList();
        }

        private void AddMaterial_Click(object sender, RoutedEventArgs e)
        {
            var mEdit = new MaterialEditWindow();
            mEdit.ShowDialog();
            LoadMaterials();
        }
    }
}'
);

-- ОКНО: RequestWindow
CREATE TABLE RequestWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO RequestWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.RequestWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Заявки" Height="450" Width="800">
    <Grid Margin="10">
        <StackPanel>
            <Button Content="Создать заявку" Click="CreateRequest_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="RequestsGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Партнер" Binding="{Binding Partner.CompanyName}" />
                    <DataGridTextColumn Header="Дата создания" Binding="{Binding CreatedDate}" />
                    <DataGridTextColumn Header="Статус" Binding="{Binding Status}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Linq;
using System.Windows;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class RequestWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public RequestWindow()
        {
            InitializeComponent();
            LoadRequests();
        }

        private void LoadRequests()
        {
            RequestsGrid.ItemsSource = _context.Requests
                .Include(r => r.Partner)
                .ToList();
        }

        private void CreateRequest_Click(object sender, RoutedEventArgs e)
        {
            var requestEdit = new RequestEditWindow();
            requestEdit.ShowDialog();
            LoadRequests();
        }
    }
}'
);

-- ОКНО: ProductionWindow
CREATE TABLE ProductionWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO ProductionWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.ProductionWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Производство" Height="400" Width="600">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="Производственные заказы"/>
            <DataGrid x:Name="ProductionGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Продукт" Binding="{Binding Product.ProductName}" />
                    <DataGridTextColumn Header="Статус" Binding="{Binding Status}" />
                    <DataGridTextColumn Header="Дата начала" Binding="{Binding StartDate}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Windows;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class ProductionWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public ProductionWindow()
        {
            InitializeComponent();
            LoadProduction();
        }

        private void LoadProduction()
        {
            ProductionGrid.ItemsSource = _context.Productions
                .Include(p => p.Product)
                .ToList();
        }
    }
}'
);

-- ОКНО: DeliveryWindow
CREATE TABLE DeliveryWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO DeliveryWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.DeliveryWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Доставка" Height="400" Width="700">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="Отгрузка продукции"/>
            <DataGrid x:Name="DeliveryGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Партнер" Binding="{Binding Partner.CompanyName}" />
                    <DataGridTextColumn Header="Дата доставки" Binding="{Binding DeliveryDate}" />
                    <DataGridTextColumn Header="Способ" Binding="{Binding DeliveryMethod}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Linq;
using System.Windows;
using WpfApp2.Data;
using Microsoft.EntityFrameworkCore;

namespace WpfApp2.Windows{
    public partial class DeliveryWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public DeliveryWindow()
        {
            InitializeComponent();
            LoadDelivery();
        }

        private void LoadDelivery()
        {
            DeliveryGrid.ItemsSource = _context.Deliveries
                .Include(d => d.Partner)
                .ToList();
        }
    }
}'
);

-- ОКНО: AccessWindow
CREATE TABLE AccessWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO AccessWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.AccessWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Доступ сотрудников" Height="400" Width="600">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="Логи доступа"/>
            <DataGrid x:Name="AccessGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Сотрудник" Binding="{Binding Employee.FullName}" />
                    <DataGridTextColumn Header="Дата входа" Binding="{Binding EntryTime}" />
                    <DataGridTextColumn Header="Локация" Binding="{Binding Door}" />
                </DataGrid.Columns>
            </DataGrid>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Windows;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class AccessWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public AccessWindow()
        {
            InitializeComponent();
            LoadAccessLogs();
        }

        private void LoadAccessLogs()
        {
            AccessGrid.ItemsSource = _context.AccessLogs
                .Include(a => a.Employee)
                .ToList();
        }
    }
}'
);

-- ОКНО: AnalyticsWindow
CREATE TABLE AnalyticsWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO AnalyticsWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.AnalyticsWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Аналитика" Height="500" Width="800">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="Отчет по продажам и сотрудникам"/>
            <ListView x:Name="AnalyticsList">
                <ListView.View>
                    <GridView>
                        <GridViewColumn Header="Название" DisplayMemberBinding="{Binding Title}" />
                        <GridViewColumn Header="Значение" DisplayMemberBinding="{Binding Value}" />
                    </GridView>
                </ListView.View>
            </ListView>
        </StackPanel>
    </Grid>
</Window>',
N'using System.Collections.Generic;
using System.Linq;
using System.Windows;
using WpfApp2.Data;

namespace WpfApp2.Windows{
    public partial class AnalyticsWindow : Window
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        public AnalyticsWindow()
        {
            InitializeComponent();
            LoadAnalytics();
        }

        private void LoadAnalytics()
        {
            var stats = new List<dynamic>
            {
                new { Title = "Общее количество сотрудников", Value = _context.Employees.Count() },
                new { Title = "Количество партнеров", Value = _context.Partners.Count() },
                new { Title = "Общее количество заявок", Value = _context.Requests.Count() }
            };

            AnalyticsList.ItemsSource = stats;
        }
    }
}'
);

CREATE TABLE BD(
NameBD VARCHAR(50) NULL,
NameD VARCHAR(MAX) NULL
);

INSERT INTO BD (NameBD,NameD)
VALUES
('Скрипт БД','-- Создание базы данных
CREATE DATABASE DBshopApp;
GO

USE DBshopApp;
GO

-- Таблица Партнеры
CREATE TABLE Partners (
    PartnerID INT IDENTITY PRIMARY KEY,
    PartnerType NVARCHAR(100) NOT NULL,
    CompanyName NVARCHAR(200) NOT NULL,
    LegalAddress NVARCHAR(300) NOT NULL,
    INN NVARCHAR(20) NOT NULL,
    DirectorFullName NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(30),
    Email NVARCHAR(100),
    Logo VARBINARY(MAX) NULL,
    Rating FLOAT DEFAULT 0,
    SalesPlaces NVARCHAR(MAX) NULL,
    SalesHistory NVARCHAR(MAX) NULL -- Можно изменить на отдельную таблицу для истории продаж
);

-- Таблица Менеджеры
CREATE TABLE Managers (
    ManagerID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    Login NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL
);

-- История изменений рейтинга партнёров
CREATE TABLE PartnerRatingHistory (
    HistoryID INT IDENTITY PRIMARY KEY,
    PartnerID INT NOT NULL,
    OldRating FLOAT NOT NULL,
    NewRating FLOAT NOT NULL,
    ChangedByManagerID INT NOT NULL,
    ChangeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID),
    FOREIGN KEY (ChangedByManagerID) REFERENCES Managers(ManagerID)
);

-- Таблица Заявки
CREATE TABLE Requests (
    RequestID INT IDENTITY PRIMARY KEY,
    PartnerID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL, -- Например: "Создана", "Отменена", "В обработке", "Выполнена"
    PrepaymentMade BIT DEFAULT 0,
    PrepaymentDate DATETIME NULL,
    FullPaymentMade BIT DEFAULT 0,
    FullPaymentDate DATETIME NULL,
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

-- Таблица Продукция
CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    Article NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    ProductType NVARCHAR(100) NOT NULL,
    MinPartnerCost DECIMAL(18,2) NOT NULL,
    MainMaterialID INT NOT NULL
);

-- Таблица Материалы (сырье)
CREATE TABLE Materials (
    MaterialID INT IDENTITY PRIMARY KEY,
    MaterialType NVARCHAR(100) NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Supplier NVARCHAR(200) NULL,
    QuantityPerPackage INT NULL,
    Unit NVARCHAR(50) NULL,
    Description NVARCHAR(MAX) NULL,
    Image VARBINARY(MAX) NULL,
    Cost DECIMAL(18,2) NOT NULL,
    QuantityInStock INT NOT NULL,
    MinQuantityAllowed INT NOT NULL
);

-- История изменения количества материалов на складе
CREATE TABLE MaterialStockHistory (
    HistoryID INT IDENTITY PRIMARY KEY,
    MaterialID INT NOT NULL,
    ChangeDate DATETIME DEFAULT GETDATE(),
    QuantityChange INT NOT NULL,
    Comment NVARCHAR(300),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);

-- Таблица Производство
CREATE TABLE Productions (
    ProductionID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    Status NVARCHAR(50) NOT NULL, -- Например: "В процессе", "Завершено"
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Таблица Доставка
CREATE TABLE Deliveries (
    DeliveryID INT IDENTITY PRIMARY KEY,
    RequestID INT NOT NULL,
    PartnerID INT NOT NULL,
    DeliveryDate DATETIME NOT NULL,
    DeliveryMethod NVARCHAR(100) NOT NULL, -- Например: "Доставка", "Самовывоз"
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

-- Таблица Сотрудники
CREATE TABLE Employees (
    EmployeeID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    BirthDate DATE NOT NULL,
    PassportData NVARCHAR(100) NOT NULL,
    BankDetails NVARCHAR(200) NOT NULL,
    HasFamily BIT NOT NULL,
    HealthStatus NVARCHAR(200) NULL
);

-- Таблица Кадры (допуск к оборудованию)
CREATE TABLE EmployeeEquipmentAccess (
    AccessID INT IDENTITY PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EquipmentName NVARCHAR(200) NOT NULL,
    AccessGrantedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Таблица Производственные цеха
CREATE TABLE Workshops (
    WorkshopID INT IDENTITY PRIMARY KEY,
    WorkshopName NVARCHAR(100) NOT NULL,
    WorkshopType NVARCHAR(100) NOT NULL,
    WorkersCount INT NOT NULL
);

-- Таблица Связь продукции и цехов (время производства)
CREATE TABLE ProductWorkshops (
    ProductID INT NOT NULL,
    WorkshopID INT NOT NULL,
    ProductionTime INT NOT NULL, -- В минутах или часах
    PRIMARY KEY (ProductID, WorkshopID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WorkshopID) REFERENCES Workshops(WorkshopID)
);

-- Таблица Доступ (учёт перемещений сотрудников)
CREATE TABLE AccessLogs (
    AccessLogID INT IDENTITY PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Door NVARCHAR(100) NOT NULL,
    EntryTime DATETIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Таблица Партнерские заявки на продукцию с деталями
CREATE TABLE RequestDetails (
    RequestDetailID INT IDENTITY PRIMARY KEY,
    RequestID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Cost DECIMAL(18,2) NOT NULL,
    ProductionDate DATE NOT NULL,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Таблица Пользователи для авторизации (например, менеджеры)
CREATE TABLE UsersDbs (
    UserID INT IDENTITY PRIMARY KEY,
    LoginName NVARCHAR(100) UNIQUE NOT NULL,
    PasswordName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Managers(ManagerID)
);

-- Индексы, ограничения и триггеры могут быть добавлены для обеспечения целостности и логики бизнес-процессов
');
