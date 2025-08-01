import pandas as pd

# Baca data pivot (anda mungkin perlu skip header tertentu)
df = pd.read_excel('pivot_data.xlsx', header=None)

data = []
current_kawasan = None

for idx, row in df.iterrows():
    # Jika baris adalah kawasan (bukan nombor, dan bukan kosong)
    if isinstance(row[0], str) and not row[0].isdigit():
        current_kawasan = row[0]
    # Jika baris adalah MRU Number (nombor)
    elif pd.notnull(row[0]) and str(row[0]).isdigit():
        data.append({
            'MRU Number': int(row[0]),
            'Nama Kawasan': current_kawasan,
            'Nilai': int(row[1])
        })

# Simpan ke Excel baru
flat_df = pd.DataFrame(data)
flat_df.to_excel('data_flat.xlsx', index=False)
print("Data telah diflat dan disimpan ke data_flat.xlsx")