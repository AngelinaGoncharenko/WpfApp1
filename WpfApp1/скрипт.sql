-- ���������� ��� ������� ����
--CREATE DATABASE WpfAppWindows;
USE WpfAppWindows

-- ������� ��� ���� OrdersWindow
CREATE TABLE OrdersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- ������� ���������� � ������ OrdersWindow
INSERT INTO OrdersWindow (Interface, Logic)
VALUES 
(
N'<Window x:Class="WpfApp2.Windows.OrdersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="������" Height="500" Width="400">
    <Grid Margin="10">
        <StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="������: " Width="120"/>
                <ComboBox x:Name="PartnerComboBox" Width="250" DisplayMemberPath="Name" SelectedValuePath="PartnerID"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="��������: " Width="120"/>
                <ComboBox x:Name="ManagerComboBox" Width="250" DisplayMemberPath="FullName" SelectedValuePath="ManagerID"/>
            </StackPanel>
            <StackPanel Orientation="Vertical" Margin="0,10,0,5">
                <TextBlock Text="��������:"/>
                <TextBox x:Name="ProductListTextBox" Height="60" AcceptsReturn="True"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="���� ������: " Width="120"/>
                <DatePicker x:Name="OrderDatePicker"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                <TextBlock Text="������: " Width="120"/>
                <TextBox x:Name="StatusTextBox" Width="200"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" Margin="0,15,0,0">
                <Button Content="��������" Width="80" Margin="5"/>
                <Button Content="���������" Width="80" Margin="5"/>
                <Button Content="�������" Width="80" Margin="5"/>
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
            ManagerComboBox.ItemsSource = _context.Employees.Where(e => e.Position == "��������").ToList();
            OrderDatePicker.SelectedDate = DateTime.Now;
        }

        private void Button_Add_Click(object sender, RoutedEventArgs e)
        {
            ProductListTextBox.Text = "";
            StatusTextBox.Text = "������� �������������";
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

                MessageBox.Show("������ ���������");
            }
            else
            {
                MessageBox.Show("�������� �������� � ���������");
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
                MessageBox.Show("������ �������");
            }
        }
    }
}'
);

-- ������� ��� ���� ManagersWindow
CREATE TABLE ManagersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- ������� ������ � ManagersWindow
INSERT INTO ManagersWindow (Interface, Logic)
VALUES
(
N'<Window x:Class="WpfApp2.Windows.ManagersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="���������" Height="400" Width="600">
    <Grid Margin="10">
        <DataGrid x:Name="ManagersGrid" AutoGenerateColumns="False" IsReadOnly="True" Margin="0,0,0,40">
            <DataGrid.Columns>
                <DataGridTextColumn Header="���" Binding="{Binding FullName}" Width="*"/>
                <DataGridTextColumn Header="Email" Binding="{Binding Email}" Width="*"/>
                <DataGridTextColumn Header="�������" Binding="{Binding Rating}" Width="*"/>
            </DataGrid.Columns>
        </DataGrid>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
            <Button Content="��������" Margin="5" Click="Refresh_Click"/>
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
                .Where(e => e.Position == "��������")
                .ToList();
        }

        private void Refresh_Click(object sender, RoutedEventArgs e)
        {
            LoadManagers();
        }
    }
}'
);

-- ������� ��� ���� PartnersWindow
CREATE TABLE PartnersWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);

-- ������� ������ � PartnersWindow
INSERT INTO PartnersWindow (Interface, Logic)
VALUES
(
N'<Window x:Class="WpfApp2.Windows.PartnersWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="��������" Height="600" Width="800">
    <Grid Margin="10">
        <DataGrid x:Name="PartnersGrid" AutoGenerateColumns="False" IsReadOnly="True" Margin="0,0,0,50">
            <DataGrid.Columns>
                <DataGridTextColumn Header="���" Binding="{Binding PartnerType}" Width="*"/>
                <DataGridTextColumn Header="��������" Binding="{Binding CompanyName}" Width="*"/>
                <DataGridTextColumn Header="���" Binding="{Binding INN}" Width="*"/>
                <DataGridTextColumn Header="Email" Binding="{Binding Email}" Width="*"/>
                <DataGridTextColumn Header="�������" Binding="{Binding Rating}" Width="*"/>
            </DataGrid.Columns>
        </DataGrid>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
            <Button Content="��������" Margin="5" Click="Add_Click"/>
            <Button Content="�������������" Margin="5" Click="Edit_Click"/>
            <Button Content="�������" Margin="5" Click="Delete_Click"/>
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


-- ��������
CREATE TABLE PartnerEditWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO PartnerEditWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.PartnerEditWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="�������������� ��������" Height="400" Width="400">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="��� ��������"/>
            <TextBox x:Name="TypeTextBox"/>
            <TextBlock Text="�������� ��������"/>
            <TextBox x:Name="CompanyNameTextBox"/>
            <TextBlock Text="���"/>
            <TextBox x:Name="INNTextBox"/>
            <TextBlock Text="Email"/>
            <TextBox x:Name="EmailTextBox"/>
            <TextBlock Text="�������"/>
            <TextBox x:Name="RatingTextBox"/>
            <Button Content="���������" Click="Save_Click" Margin="0,10,0,0"/>
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

-- ����������
CREATE TABLE EmployeeWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO EmployeeWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.EmployeeWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="����������" Height="400" Width="600">
    <Grid>
        <StackPanel Margin="10">
            <Button Content="�������� ����������" Click="AddEmployee_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="EmployeesGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="���" Binding="{Binding FullName}" />
                    <DataGridTextColumn Header="���� ��������" Binding="{Binding BirthDate}" />
                    <DataGridTextColumn Header="�������" Binding="{Binding Passport}" />
                    <DataGridTextColumn Header="�����" Binding="{Binding FamilyStatus}" />
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

-- ����: MaterialsWindow
CREATE TABLE MaterialsWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO MaterialsWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.MaterialsWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="���������" Height="400" Width="700">
    <Grid Margin="10">
        <StackPanel>
            <Button Content="�������� ��������" Click="AddMaterial_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="MaterialsGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="���" Binding="{Binding MaterialType}" />
                    <DataGridTextColumn Header="������ (%)" Binding="{Binding LossPercentage}" />
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

-- ����: RequestWindow
CREATE TABLE RequestWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO RequestWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.RequestWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="������" Height="450" Width="800">
    <Grid Margin="10">
        <StackPanel>
            <Button Content="������� ������" Click="CreateRequest_Click" Margin="0,0,0,10"/>
            <DataGrid x:Name="RequestsGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="�������" Binding="{Binding Partner.CompanyName}" />
                    <DataGridTextColumn Header="���� ��������" Binding="{Binding CreatedDate}" />
                    <DataGridTextColumn Header="������" Binding="{Binding Status}" />
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

-- ����: ProductionWindow
CREATE TABLE ProductionWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO ProductionWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.ProductionWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="������������" Height="400" Width="600">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="���������������� ������"/>
            <DataGrid x:Name="ProductionGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="�������" Binding="{Binding Product.ProductName}" />
                    <DataGridTextColumn Header="������" Binding="{Binding Status}" />
                    <DataGridTextColumn Header="���� ������" Binding="{Binding StartDate}" />
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

-- ����: DeliveryWindow
CREATE TABLE DeliveryWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO DeliveryWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.DeliveryWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="��������" Height="400" Width="700">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="�������� ���������"/>
            <DataGrid x:Name="DeliveryGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="�������" Binding="{Binding Partner.CompanyName}" />
                    <DataGridTextColumn Header="���� ��������" Binding="{Binding DeliveryDate}" />
                    <DataGridTextColumn Header="������" Binding="{Binding DeliveryMethod}" />
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

-- ����: AccessWindow
CREATE TABLE AccessWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO AccessWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.AccessWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="������ �����������" Height="400" Width="600">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="���� �������"/>
            <DataGrid x:Name="AccessGrid" AutoGenerateColumns="False" IsReadOnly="True">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="���������" Binding="{Binding Employee.FullName}" />
                    <DataGridTextColumn Header="���� �����" Binding="{Binding EntryTime}" />
                    <DataGridTextColumn Header="�������" Binding="{Binding Door}" />
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

-- ����: AnalyticsWindow
CREATE TABLE AnalyticsWindow (
    Interface NVARCHAR(MAX),
    Logic NVARCHAR(MAX)
);
INSERT INTO AnalyticsWindow (Interface, Logic)
VALUES (
N'<Window x:Class="WpfApp2.Windows.AnalyticsWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="���������" Height="500" Width="800">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock Text="����� �� �������� � �����������"/>
            <ListView x:Name="AnalyticsList">
                <ListView.View>
                    <GridView>
                        <GridViewColumn Header="��������" DisplayMemberBinding="{Binding Title}" />
                        <GridViewColumn Header="��������" DisplayMemberBinding="{Binding Value}" />
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
                new { Title = "����� ���������� �����������", Value = _context.Employees.Count() },
                new { Title = "���������� ���������", Value = _context.Partners.Count() },
                new { Title = "����� ���������� ������", Value = _context.Requests.Count() }
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
('������ ��','-- �������� ���� ������
CREATE DATABASE DBshopApp;
GO

USE DBshopApp;
GO

-- ������� ��������
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
    SalesHistory NVARCHAR(MAX) NULL -- ����� �������� �� ��������� ������� ��� ������� ������
);

-- ������� ���������
CREATE TABLE Managers (
    ManagerID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    Login NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL
);

-- ������� ��������� �������� ��������
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

-- ������� ������
CREATE TABLE Requests (
    RequestID INT IDENTITY PRIMARY KEY,
    PartnerID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL, -- ��������: "�������", "��������", "� ���������", "���������"
    PrepaymentMade BIT DEFAULT 0,
    PrepaymentDate DATETIME NULL,
    FullPaymentMade BIT DEFAULT 0,
    FullPaymentDate DATETIME NULL,
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

-- ������� ���������
CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    Article NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    ProductType NVARCHAR(100) NOT NULL,
    MinPartnerCost DECIMAL(18,2) NOT NULL,
    MainMaterialID INT NOT NULL
);

-- ������� ��������� (�����)
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

-- ������� ��������� ���������� ���������� �� ������
CREATE TABLE MaterialStockHistory (
    HistoryID INT IDENTITY PRIMARY KEY,
    MaterialID INT NOT NULL,
    ChangeDate DATETIME DEFAULT GETDATE(),
    QuantityChange INT NOT NULL,
    Comment NVARCHAR(300),
    FOREIGN KEY (MaterialID) REFERENCES Materials(MaterialID)
);

-- ������� ������������
CREATE TABLE Productions (
    ProductionID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    Status NVARCHAR(50) NOT NULL, -- ��������: "� ��������", "���������"
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ������� ��������
CREATE TABLE Deliveries (
    DeliveryID INT IDENTITY PRIMARY KEY,
    RequestID INT NOT NULL,
    PartnerID INT NOT NULL,
    DeliveryDate DATETIME NOT NULL,
    DeliveryMethod NVARCHAR(100) NOT NULL, -- ��������: "��������", "���������"
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

-- ������� ����������
CREATE TABLE Employees (
    EmployeeID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    BirthDate DATE NOT NULL,
    PassportData NVARCHAR(100) NOT NULL,
    BankDetails NVARCHAR(200) NOT NULL,
    HasFamily BIT NOT NULL,
    HealthStatus NVARCHAR(200) NULL
);

-- ������� ����� (������ � ������������)
CREATE TABLE EmployeeEquipmentAccess (
    AccessID INT IDENTITY PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EquipmentName NVARCHAR(200) NOT NULL,
    AccessGrantedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ������� ���������������� ����
CREATE TABLE Workshops (
    WorkshopID INT IDENTITY PRIMARY KEY,
    WorkshopName NVARCHAR(100) NOT NULL,
    WorkshopType NVARCHAR(100) NOT NULL,
    WorkersCount INT NOT NULL
);

-- ������� ����� ��������� � ����� (����� ������������)
CREATE TABLE ProductWorkshops (
    ProductID INT NOT NULL,
    WorkshopID INT NOT NULL,
    ProductionTime INT NOT NULL, -- � ������� ��� �����
    PRIMARY KEY (ProductID, WorkshopID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WorkshopID) REFERENCES Workshops(WorkshopID)
);

-- ������� ������ (���� ����������� �����������)
CREATE TABLE AccessLogs (
    AccessLogID INT IDENTITY PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Door NVARCHAR(100) NOT NULL,
    EntryTime DATETIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ������� ����������� ������ �� ��������� � ��������
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

-- ������� ������������ ��� ����������� (��������, ���������)
CREATE TABLE UsersDbs (
    UserID INT IDENTITY PRIMARY KEY,
    LoginName NVARCHAR(100) UNIQUE NOT NULL,
    PasswordName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Managers(ManagerID)
);

-- �������, ����������� � �������� ����� ���� ��������� ��� ����������� ����������� � ������ ������-���������
');
