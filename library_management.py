import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from functools import partial

db_connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="12345678",
    database="LIBRARY_MANAGEMENT"
)
cursor = db_connection.cursor()

class LibraryManagementSystem(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Library Management System")
        self.geometry("1000x600")

        self.current_section = None
        self.sort_orders = {}

        self.left_frame = tk.Frame(self, width=200, bg="#D3D3D3")
        self.left_frame.pack(side=tk.LEFT, fill=tk.Y)

        sections = ["Books", "Readers", "Employees", "Loans", "Overdue Books"]
        self.section_buttons = {}
        for section in sections:
            btn = tk.Button(self.left_frame, text=section, command=partial(self.load_section, section))
            btn.pack(fill=tk.X, padx=5, pady=5)
            self.section_buttons[section] = btn

        self.top_frame = tk.Frame(self)
        self.top_frame.pack(side=tk.TOP, fill=tk.X)

        self.add_button = tk.Button(self.top_frame, text="Add", command=self.add_entry)
        self.add_button.pack(side=tk.LEFT, padx=5, pady=5)

        self.delete_button = tk.Button(self.top_frame, text="Delete", command=self.delete_entry)
        self.delete_button.pack(side=tk.LEFT, padx=5, pady=5)

        self.edit_button = tk.Button(self.top_frame, text="Edit", command=self.edit_entry)
        self.edit_button.pack(side=tk.LEFT, padx=5, pady=5)

        self.current_section_label = tk.Label(self.top_frame, text="", font=("Arial", 12))
        self.current_section_label.pack(side=tk.RIGHT, padx=5)

        self.table_frame = tk.Frame(self)
        self.table_frame.pack(fill=tk.BOTH, expand=True)

        self.table = ttk.Treeview(self.table_frame, columns=(), show='headings')
        self.table.pack(fill=tk.BOTH, expand=True)

        self.load_section("Books")

    def load_section(self, section):
        self.current_section = section
        self.current_section_label.config(text=f"Section: {section}")
        self.table.delete(*self.table.get_children())
        self.sort_orders.clear()

        if section == "Overdue Books":
            self.add_button.pack_forget()
            self.delete_button.pack_forget()
            self.edit_button.pack_forget()
        else:
            self.add_button.pack(side=tk.LEFT, padx=5, pady=5)
            self.delete_button.pack(side=tk.LEFT, padx=5, pady=5)
            self.edit_button.pack(side=tk.LEFT, padx=5, pady=5)

        if section == "Books":
            self.load_books()
        elif section == "Readers":
            self.load_readers()
        elif section == "Employees":
            self.load_employees()
        elif section == "Loans":
            self.load_loans()
        elif section == "Overdue Books":
            self.load_overdue_books()

    def add_entry(self):
        add_window = tk.Toplevel(self)
        add_window.title("Add New Entry")
        add_window.geometry("250x250")

        current_section = self.current_section

        cursor.execute(f"DESCRIBE {current_section}")
        columns = [desc[0] for desc in cursor.fetchall()]

        def validate_input(p):
            return p.isdigit() or p == ""

        validate_cmd = (add_window.register(validate_input), "%P")

        entries = {}
        for idx, column in enumerate(columns):
            if column.lower() in ("book_id", "created_at","employee_id","reader_id","loan_id","employee_id","return_date"):
                continue
            tk.Label(add_window, text=column).grid(row=idx, column=0, padx=5, pady=5)

            if column in ["Published_Year", "Available"]:
                entry = tk.Entry(add_window, validate="key", validatecommand=validate_cmd)
            else:
                entry = tk.Entry(add_window)
            entry.grid(row=idx, column=1, padx=5, pady=5)
            entries[column] = entry

        def save_new_entry():
            values = {col_name: field.get() for col_name, field in entries.items()}

            if 'Published_Year' in values and not values['Published_Year'].isdigit():
                messagebox.showerror("Input Error", "Please enter a valid year for Published_Year.")
                return

            if 'Available' in values and not values['Available'].isdigit():
                messagebox.showerror("Input Error", "Please enter a valid number for Available.")
                return

            placeholders = ', '.join(['%s'] * len(values))
            columns_str = ', '.join(values.keys())
            sql = f"INSERT INTO {current_section} ({columns_str}) VALUES ({placeholders})"

            try:
                cursor.execute(sql, list(values.values()))
                db_connection.commit()
                messagebox.showinfo("Success", f"New entry added to {current_section}!")
                add_window.destroy()
                self.load_section(current_section)
            except mysql.connector.Error as e:
                messagebox.showerror("Database Error", f"Error: {e}")

        save_button = tk.Button(add_window, text="Save", command=save_new_entry)
        save_button.grid(row=len(columns), column=0, columnspan=2, pady=10)

    @staticmethod
    def get_primary_key_column(table_name):
        cursor.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
        result = cursor.fetchone()
        if result:
            return result[4]
        return None

    def delete_entry(self):
        selected_item = self.table.selection()
        if not selected_item:
            messagebox.showwarning("Select an Entry", "Please select an entry to delete.")
            return

        current_section = self.current_section
        primary_key_column = self.get_primary_key_column(current_section)

        if not primary_key_column:
            messagebox.showerror("Database Error", f"Primary key not found for table {current_section}.")
            return

        item_data = self.table.item(selected_item[0])
        record_id = item_data['values'][0]

        confirm = messagebox.askyesno("Confirm Delete", "Are you sure you want to delete this entry?")
        if confirm:
            try:
                sql = f"DELETE FROM {current_section} WHERE {primary_key_column} = %s"
                cursor.execute(sql, (record_id,))
                db_connection.commit()

                messagebox.showinfo("Deleted", "The entry has been deleted.")
                self.load_section(current_section)
            except mysql.connector.Error as e:
                messagebox.showerror("Database Error", f"Error: {e}")

    def edit_entry(self):
        selected_item = self.table.selection()
        if not selected_item:
            messagebox.showwarning("Select an Entry", "Please select an entry to edit.")
            return

        current_section = self.current_section

        primary_key_column = self.get_primary_key_column(current_section)
        if not primary_key_column:
            messagebox.showerror("Error", "Primary key not found for the table.")
            return

        item_data = self.table.item(selected_item[0])
        record_id = item_data['values'][0]

        edit_window = tk.Toplevel(self)
        edit_window.title("Edit Entry")
        edit_window.geometry("400x300")

        cursor.execute(f"DESCRIBE {current_section}")
        columns = [desc[0] for desc in cursor.fetchall()]

        entries = {}
        for idx, column_name in enumerate(columns):
            if column_name == primary_key_column:
                continue
            tk.Label(edit_window, text=column_name).grid(row=idx, column=0, padx=5, pady=5)

            entry_field = tk.Entry(edit_window)
            entry_field.insert(0, item_data['values'][idx])
            entry_field.grid(row=idx, column=1, padx=5, pady=5)
            entries[column_name] = entry_field

        def save_edited_entry():
            values = {column: entry.get() for column, entry in entries.items()}
            set_clause = ', '.join([f"{column}=%s" for column in values.keys()])
            sql = f"UPDATE {current_section} SET {set_clause} WHERE {primary_key_column}=%s"

            try:
                cursor.execute(sql, list(values.values()) + [record_id])
                db_connection.commit()
                messagebox.showinfo("Success", f"Entry in {current_section} updated!")
                edit_window.destroy()
                self.load_section(current_section)
            except mysql.connector.Error as e:
                messagebox.showerror("Database Error", f"Error: {e}")

        save_button = tk.Button(edit_window, text="Save", command=save_edited_entry)
        save_button.grid(row=len(columns), column=0, columnspan=2, pady=10)

    def load_books(self):
        cursor.execute("SELECT * FROM Books")
        columns = [desc[0] for desc in cursor.description]
        self.table["columns"] = columns
        for col in columns:
            self.table.heading(col, text=col, command=lambda _col=col: self.sort_column(_col))
            self.table.column(col, width=100)

        for row in cursor.fetchall():
            self.table.insert("", "end", values=row)

    def load_readers(self):
        cursor.execute("SELECT * FROM Readers")
        columns = [desc[0] for desc in cursor.description]
        self.table["columns"] = columns
        for col in columns:
            self.table.heading(col, text=col, command=lambda _col=col: self.sort_column(_col))
            self.table.column(col, width=100)

        for row in cursor.fetchall():
            self.table.insert("", "end", values=row)


    def load_employees(self):
        cursor.execute("SELECT * FROM Employees")
        columns = [desc[0] for desc in cursor.description]
        self.table["columns"] = columns
        for col in columns:
            self.table.heading(col, text=col, command=lambda _col=col: self.sort_column(_col))
            self.table.column(col, width=100)

        for row in cursor.fetchall():
            self.table.insert("", "end", values=row)

    def load_loans(self):
        cursor.execute("SELECT * FROM Loans")
        columns = [desc[0] for desc in cursor.description]
        self.table["columns"] = columns
        for col in columns:
            self.table.heading(col, text=col, command=lambda _col=col: self.sort_column(_col))
            self.table.column(col, width=100)

        for row in cursor.fetchall():
            self.table.insert("", "end", values=row)

    def load_overdue_books(self):
        cursor.execute("SELECT * FROM OverdueBooks")
        columns = [desc[0] for desc in cursor.description]
        self.table["columns"] = columns
        for col in columns:
            self.table.heading(col, text=col, command=lambda _col=col: self.sort_column(_col))
            self.table.column(col, width=100)

        for row in cursor.fetchall():
            self.table.insert("", "end", values=row)

    def sort_column(self, col):
        ascending = self.sort_orders.get(col, True)

        data = [(self.table.set(item, col), item) for item in self.table.get_children("")]


        try:
            data.sort(key=lambda t: float(t[0]) if t[0] else 0, reverse=not ascending)
        except ValueError:
            data.sort(key=lambda t: t[0], reverse=not ascending)

        for index, (_, item) in enumerate(data):
            self.table.move(item, "", index)

        self.sort_orders[col] = not ascending

app = LibraryManagementSystem()
app.mainloop()