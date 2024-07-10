#==============MULTISTAGE BUILDING================
FROM golang:1.22.4-alpine AS builder

WORKDIR /app

#Setting up dependencies and initial files
COPY go.mod go.sum ./

RUN go download & go mod verify
#Getting the actual project files
COPY . .

#Building the binary file for the app (-o is the output path flag).
#For that, the app entrypoint/bootstrap file is needed
RUN go build -o /bin/journey ./cmd/journey/journey.go

#A minimal image used basically for executing the needed files
FROM scratch

WORKDIR /clean-app

#Gets the bin file from the previous build stage and puts it in the new context
COPY --from=builder /bin/journey .

EXPOSE 8080

#Executing the journey bin file, the only one in the new WORKDIR /clean-app
ENTRYPOINT ["./journey"]







#==============BLOATED DOCKERFILE================
# FROM golang:1.22.4-alpine

# WORKDIR /app

# #Setting up dependencies and initial files
# COPY go.mod go.sum ./

# RUN go download & go mod verify
# #Getting the actual project files
# COPY . .

# #Building the binary file for the app (-o is the output path flag).
# #For that, the app entrypoint/bootstrap file is needed
# RUN go build -o /bin/journey ./cmd/journey/journey.go

# EXPOSE 8080

# ENTRYPOINT ["/bin/journey"]