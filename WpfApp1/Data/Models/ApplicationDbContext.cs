using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace WpfApp1.Data.Models;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<TestDatum> TestData { get; set; }

    public virtual DbSet<UsersDb> UsersDbs { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=DESKTOP-PF93MTG;Database=TestingBd;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TestDatum>(entity =>
        {
            entity.HasKey(e => e.TestId).HasName("PK__TestData__8CC33160E1B81E8E");

            entity.Property(e => e.Text)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.User).WithMany(p => p.TestData)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__TestData__UserId__3C69FB99");
        });

        modelBuilder.Entity<UsersDb>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__UsersDB__1788CC4C66984B12");

            entity.ToTable("UsersDB");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
