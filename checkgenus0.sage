from lmfdb import db

with open("genus0results.txt", "w") as g:
    with open("genus0maxtwist.txt", "r") as f:
        for line in f:
            label = line.strip()          # remove newline / spaces

            if not label:
                continue                  # skip empty lines

            if label == '1.1.0.a.1':
                continue

            res = db.modcurve_modelmaps.lucky(
                {'codomain_label': '1.1.0.a.1', 'domain_label': label},
                projection=["coordinates", "leading_coefficients"]
            )

            # If there is no result at all:
            if res is None:
                print("No result for", label)
                g.write(f"{label} None None\n")
                continue

            coords = res.get('coordinates')
            leading = res.get('leading_coefficients')

            if coords is None:
                print("No coordinates for", label)

            if leading is None:
                leading = ['1', '1']

            # Make sure everything is a string before writing
            g.write(f"{label} {coords} {leading}\n")
