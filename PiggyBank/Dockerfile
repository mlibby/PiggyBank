#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0-preview AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build
WORKDIR /src
COPY ["PiggyBank/PiggyBank.csproj", "PiggyBank/"]
RUN dotnet restore "PiggyBank/PiggyBank.csproj"
COPY . .
WORKDIR "/src/PiggyBank"
RUN dotnet build "PiggyBank.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PiggyBank.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PiggyBank.dll"]